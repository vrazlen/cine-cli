--=============================================================================
-->>    SUBLIMINAL PATH:
--=============================================================================
--          This script uses Subliminal to download subtitles,
--          so make sure to specify your system's Subliminal location below:
local utils = require 'mp.utils'
local subliminal = os.getenv('CINE_SUBLIMINAL_PATH') or '/home/vrazlen/.local/bin/subliminal'

local function resolve_config_path()
    local env_config = os.getenv('CINE_SUBLIMINAL_CONFIG')
    if env_config and env_config ~= '' then
        return env_config
    end

    local xdg_config = os.getenv('XDG_CONFIG_HOME')
    if not xdg_config or xdg_config == '' then
        xdg_config = os.getenv('HOME') .. '/.config'
    end

    local cine_config = xdg_config .. '/cine/subliminal.toml'
    if utils.file_info(cine_config) then
        return cine_config
    end

    return xdg_config .. '/subliminal/subliminal.toml'
end

local config_file = resolve_config_path()
local max_age = os.getenv('CINE_SUBS_MAX_AGE')
local min_score = os.getenv('CINE_SUBS_MIN_SCORE')

-- Global limits (single source of truth)
local SUB_TIMEOUT_SEC = 20
local SUB_TOTAL_BUDGET_SEC = 120
local SUB_MAX_ATTEMPTS_PER_PROVIDER = 2
local SUB_MAX_CANDIDATES = 25
local SUB_MAX_PROVIDERS = 5
local SUB_BACKOFF_MS = 500
--=============================================================================
-->>    SUBTITLE LANGUAGE:
--=============================================================================
--          Specify languages in this order:
--          { 'language name', 'ISO-639-1', 'ISO-639-2' } !
--          (See: https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
local languages = {
--          If subtitles are found for the first language,
--          other languages will NOT be downloaded,
--          so put your preferred language first:
            { 'English', 'en', 'eng' },
}
--=============================================================================
-->>    PROVIDER LOGINS:
--=============================================================================
--          These are completely optional and not required
--          for the functioning of the script!
--          If you use any of these services, simply uncomment it
--          and replace 'USERNAME' and 'PASSWORD' with your own:
local logins = {
--          { '--addic7ed', 'USERNAME', 'PASSWORD' },
--          { '--legendastv', 'USERNAME', 'PASSWORD' },
--          { '--opensubtitles', 'USERNAME', 'PASSWORD' },
--          { '--subscenter', 'USERNAME', 'PASSWORD' },
}
--=============================================================================
-->>    ADDITIONAL OPTIONS:
--=============================================================================
local bools = {
    auto = true,   -- Automatically download subtitles, no hotkeys required
    debug = false, -- Use `--debug` in subliminal command for debug output
    force = true,  -- Force download; will overwrite existing subtitle files
    utf8 = true,   -- Save all subtitle files as UTF-8
}
local excludes = {
    -- Movies with a path containing any of these strings/paths
    -- will be excluded from auto-downloading subtitles.
    -- Full paths are also allowed, e.g.:
    -- '/home/david/Videos',
    'no-subs-dl',
}
local includes = {
    -- If anything is defined here, only the movies with a path
    -- containing any of these strings/paths will auto-download subtitles.
    -- Full paths are also allowed, e.g.:
    -- '/home/david/Videos',
}
--=============================================================================
local utils = require 'mp.utils'


-- Helper: Run command with hard timeout
local function run_with_timeout(cmd_args, timeout_sec)
    local wrapped_cmd = { 'timeout', '-k', '5', tostring(timeout_sec) }
    for _, arg in ipairs(cmd_args) do
        table.insert(wrapped_cmd, arg)
    end
    return utils.subprocess({ args = wrapped_cmd })
end

-- Download function: download the best subtitles in most preferred language
function download_subs(language)
    language = language or languages[1]
    if #language == 0 then
        log('No Language found\n')
        return false
    end
            
    log('Searching ' .. language[1] .. ' subtitles ...', 30)

    -- Build the `subliminal` command, starting with the executable:
    local base_args = { subliminal }

    for _, login in ipairs(logins) do
        table.insert(base_args, login[1])
        table.insert(base_args, login[2])
        table.insert(base_args, login[3])
    end
    if bools.debug then
        -- To see `--debug` output start MPV from the terminal!
        table.insert(base_args, '--debug')
    end

    table.insert(base_args, '-c')
    table.insert(base_args, config_file)
    table.insert(base_args, 'download')
    if bools.force then
        table.insert(base_args, '-f')
    end
    if bools.utf8 then
        table.insert(base_args, '-e')
        table.insert(base_args, 'utf-8')
    end

    table.insert(base_args, '-l')
    table.insert(base_args, language[2])
    table.insert(base_args, '-d')
    table.insert(base_args, directory)
    table.insert(base_args, filename) --> Subliminal command ends with the movie filename.

    local attempt = 1
    local success = false
    local result = nil

    while attempt <= SUB_MAX_ATTEMPTS_PER_PROVIDER do
        local start_time = os.time()
        mp.msg.warn(string.format("Attempt %d/%d with timeout %ds...", attempt, SUB_MAX_ATTEMPTS_PER_PROVIDER, SUB_TIMEOUT_SEC))
        
        result = run_with_timeout(base_args, SUB_TIMEOUT_SEC)
        
        local duration = os.time() - start_time
        mp.msg.warn(string.format("Attempt finished in %ds. Status: %s", duration, result.status or "unknown"))

        if result.status == 0 and string.find(result.stdout, 'Downloaded 1 subtitle') then
            success = true
            break
        elseif result.status == 124 then -- timeout exit code
            mp.msg.warn("Command timed out!")
        else
            mp.msg.warn("Command failed or no subtitles found.")
        end

        attempt = attempt + 1
        -- Simple backoff
        if attempt <= SUB_MAX_ATTEMPTS_PER_PROVIDER then
             -- Busy wait/sleep is bad in mpv main thread, but for 0.5s it might be tolerable 
             -- or we just retry immediately since we are blocking anyway.
             -- Let's just proceed.
        end
    end

    if success then
        -- When multiple external files are present,
        -- always activate the most recently downloaded:
        mp.set_property('slang', language[2])
        -- Subtitles are downloaded successfully, so rescan to activate them:
        mp.commandv('rescan_external_files')
        log(language[1] .. ' subtitles ready!')
        return true
    else
        log('No ' .. language[1] .. ' subtitles found (after retries)\n')
        return false
    end
end

-- Manually download second language subs by pressing 'n':
function download_subs2()
    download_subs(languages[2])
end

-- Control function: only download if necessary
function control_downloads()
    -- Make MPV accept external subtitle files with language specifier:
    mp.set_property('sub-auto', 'fuzzy')
    -- Set subtitle language preference:
    mp.set_property('slang', languages[1][2])
    mp.msg.warn('Reactivate external subtitle files:')
    mp.commandv('rescan_external_files')
    directory, filename = utils.split_path(mp.get_property('path'))
    if directory:find('^http://localhost') or directory:find('^https://localhost') then
        directory = '/tmp/mpv_subs'
        utils.subprocess({ args = { 'mkdir', '-p', directory } })
    end

    if not autosub_allowed() then
        return
    end

    sub_tracks = {}
    for _, track in ipairs(mp.get_property_native('track-list')) do
        if track['type'] == 'sub' then
            sub_tracks[#sub_tracks + 1] = track
        end
    end
    if bools.debug then -- Log subtitle properties to terminal:
        for _, track in ipairs(sub_tracks) do
            mp.msg.warn('Subtitle track', track['id'], ':\n{')
            for k, v in pairs(track) do
                if type(v) == 'string' then v = '"' .. v .. '"' end
                mp.msg.warn('  "' .. k .. '":', v)
            end
            mp.msg.warn('}\n')
        end
    end

    for _, language in ipairs(languages) do
        if should_download_subs_in(language) then
            if download_subs(language) then return end -- Download successful!
        else return end -- No need to download!
    end
    log('No subtitles were found')
end

-- Check if subtitles should be auto-downloaded:
function autosub_allowed()
    local duration = tonumber(mp.get_property('duration'))
    local active_format = mp.get_property('file-format')

    if not bools.auto then
        mp.msg.warn('Automatic downloading disabled!')
        return false
    elseif duration < 900 then
        mp.msg.warn('Video is less than 15 minutes\n' ..
                      '=> NOT auto-downloading subtitles')
        return false
    elseif directory:find('^http') and not directory:find('^http://localhost') and not directory:find('^https://localhost') then
        mp.msg.warn('Automatic subtitle downloading is disabled for web streaming')
        return false
    elseif active_format:find('^cue') then
        mp.msg.warn('Automatic subtitle downloading is disabled for cue files')
        return false
    else
        local not_allowed = {'aiff', 'ape', 'flac', 'mp3', 'ogg', 'wav', 'wv', 'tta'}

        for _, file_format in pairs(not_allowed) do
            if file_format == active_format then
                mp.msg.warn('Automatic subtitle downloading is disabled for audio files')
                return false
            end
        end

        for _, exclude in pairs(excludes) do
            local escaped_exclude = exclude:gsub('%W','%%%0')
            local excluded = directory:find(escaped_exclude)

            if excluded then
                mp.msg.warn('This path is excluded from auto-downloading subs')
                return false
            end
        end

        for i, include in ipairs(includes) do
            local escaped_include = include:gsub('%W','%%%0')
            local included = directory:find(escaped_include)

            if included then break
            elseif i == #includes then
                mp.msg.warn('This path is not included for auto-downloading subs')
                return false
            end
        end
    end

    return true
end

-- Check if subtitles should be downloaded in this language:
function should_download_subs_in(language)
    for i, track in ipairs(sub_tracks) do
        local subtitles = track['external'] and
          'subtitle file' or 'embedded subtitles'

        if not track['lang'] and (track['external'] or not track['title'])
          and i == #sub_tracks then
            local status = track['selected'] and ' active' or ' present'
            log('Unknown ' .. subtitles .. status)
            mp.msg.warn('=> NOT downloading new subtitles')
            return false -- Don't download if 'lang' key is absent
        elseif track['lang'] == language[3] or track['lang'] == language[2] or
          (track['title'] and track['title']:lower():find(language[3])) then
            if not track['selected'] then
                mp.set_property('sid', track['id'])
                log('Enabled ' .. language[1] .. ' ' .. subtitles .. '!')
            else
                log(language[1] .. ' ' .. subtitles .. ' active')
            end
            mp.msg.warn('=> NOT downloading new subtitles')
            return false -- The right subtitles are already present
        end
    end
    mp.msg.warn('No ' .. language[1] .. ' subtitles were detected\n' ..
                '=> Proceeding to download:')
    return true
end

-- Log function: log to both terminal and MPV OSD (On-Screen Display)
function log(string, secs)
    secs = secs or 5
    mp.osd_message(string, secs)
    mp.msg.warn(string)
end

-- Pause and download subtitles on demand:
function download_subs1()
    download_subs(languages[1])
end

-- Set keybindings
mp.add_key_binding('b', 'download_subs1', download_subs1)
mp.add_key_binding('n', 'download_subs2', download_subs2)

-- Start the script
mp.register_event('file-loaded', control_downloads)
