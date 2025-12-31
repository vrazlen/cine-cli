# Cine-CLI

Fast CLI workflow for streaming/downloading torrents with resume and auto-subtitles.

## Commands
- Run: `cine`
- Menu: `n` (New), `r` (Resume)

## Workflow
1. Search query
2. Quality filter: `1080`, `720`, `4k`, `any` (default: 1080)
3. Select result (ranked by quality + seeders)
4. Choose `s` (Stream) or `d` (Download)

## Library Layout
- Incoming: `~/Videos/Library/Incoming`
- Movies: `~/Videos/Library/Movies`
- Series: `~/Videos/Library/Series`

## Resume
- History: `~/.local/share/cine-cli/history.jsonl`
- Uses MPV resume and a custom position log.

## Subtitles
- Config: `~/.config/subliminal/subliminal.toml`
- Template: `config/subliminal/subliminal.toml.template`

## Services
- Jackett user service: `systemd/jackett.service`

## Install
- Symlink configs to your home:
  - `~/.config/mpv/mpv.conf`
  - `~/.config/mpv/scripts/autosub.lua`
  - `~/.config/mpv/script-opts/webtorrent.conf`
- Place your real Subliminal config in `~/.config/subliminal/subliminal.toml`
- Enable Jackett:
  - `systemctl --user enable --now jackett.service`
