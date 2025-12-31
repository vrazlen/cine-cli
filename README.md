# Cine-CLI

Fast, interactive CLI workflow for streaming/downloading torrents with resume capabilities and robust auto-subtitles.

## Features
- **Interactive First**: Frictionless search and selection via `fzf`.
- **Resume**: Automatically tracks playback position; resume instantly with `cine -r`.
- **Smart Sorting**: Ranks results by quality (4K > 1080p > 720p) and seeder count.
- **Auto-Subtitles**: Prioritizes OpenSubtitles.com with robust free fallback providers (Podnapisi, TVSubtitles).
- **Free-Only**: Designed for public/free trackers; no paid subscriptions required.
- **XDG Compliant**: Configs in `~/.config`, data in `~/.local/share`.

## Usage

**Interactive Search:**
```bash
cine
# or skip the prompt:
cine "Blade Runner"
```

**Resume Playback:**
```bash
cine -r
# or
cine --resume
```

**During Selection:**
- `Enter`: Stream
- `Ctrl+D`: Download
- `Ctrl+Y`: Copy Magnet Link

## Configuration

**Environment Variables** (override defaults):
- `INDEXER_PROVIDER`: `jackett` (default)
- `INDEXER_BASE_URL`: URL to Jackett/Prowlarr (default: `http://127.0.0.1:9117`)
- `INDEXER_API_KEY`: Your API Key (auto-detected from `~/.config/Jackett/ServerConfig.json` if available)
- `INDEXER_TIMEOUT`: Search timeout in seconds (default: 15)

**Files:**
- Config: `~/.config/cine/` (or `~/.config/subliminal/`)
- History: `~/.local/share/cine-cli/history.jsonl`
- Library: `~/Videos/Library/{Movies,Series}`

## Subtitles
Uses `subliminal` with a configured provider chain:
1. **OpenSubtitles.com** (Primary, requires free API key)
2. **Podnapisi** (Free fallback)
3. **TVSubtitles** (Free fallback for series)

MPV Hotkeys:
- `b`: Download English subs (Primary)
- `n`: Download Secondary subs

## Installation
1. **Dependencies**: `mpv`, `aria2`, `jq`, `fzf`, `python3`, `curl`, `subliminal`
2. **Services**: Ensure Jackett is running (`systemctl --user enable --now jackett.service`).
3. **Setup**:
   ```bash
   # Symlink configs
   ln -s $(pwd)/config/mpv ~/.config/mpv
   mkdir -p ~/.config/subliminal
   cp config/subliminal/subliminal.toml.template ~/.config/subliminal/subliminal.toml
   # Edit subliminal.toml with your OpenSubtitles.com credentials
   ```
