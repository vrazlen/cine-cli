# TODO

## Locked Preferences (Requirements)
- Free-only indexers; no paid subscriptions; no accounts assumed by default.
- Interactive prompts are primary UX; flags optional.
- English subtitles; prioritize OpenSubtitles.com; auto-fallback to free sources.
- Unified config/storage (XDG-style); no scattered dotfiles.
- Output must be clear and readable; logs actionable with optional detailed mode.

## Epic 0: Bootstrap
- [x] Task 0.1: Confirm workflow repos and identify work repo
  - Objective: Verify required repo paths and select cine-cli as work repo.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Paths exist; work repo confirmed; notes recorded.
  - Owner Agent: Sisyphus
  - Tooling: glob
  - Dependencies: None
- [x] Task 0.2: Establish canonical TODO system
  - Objective: Create TODO.md and sync OpenCode todos 1:1.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): TODO.md exists with this plan; OpenCode todos match.
  - Owner Agent: Sisyphus
  - Tooling: write, todowrite
  - Dependencies: Task 0.1

## Epic 1: Deep Scan / Baseline
- [x] Task 1.1: Map CLI UX flow and entrypoints
  - Objective: Identify CLI entrypoints, command flow, and UX patterns.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Current State Report section with file paths.
  - Owner Agent: Explore
  - Tooling: read, grep, rg, lsp_document_symbols
  - Dependencies: Task 0.2
- [x] Task 1.2: Map autosub flow
  - Objective: Trace autosub integration and config usage.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Current State Report section with file paths and behavior.
  - Owner Agent: Explore
  - Tooling: read, grep, rg, ast_grep_search
  - Dependencies: Task 0.2
- [x] Task 1.3: Map indexer integration points
  - Objective: Locate Jackett/Prowlarr usage and service integration.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Current State Report section with file paths and behavior.
  - Owner Agent: Explore
  - Tooling: read, grep, rg
  - Dependencies: Task 0.2
- [x] Task 1.4: Produce Current State Report artifact
  - Objective: Consolidate baseline findings.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Report in repo with links to files and flows.
  - Owner Agent: Sisyphus
  - Tooling: write
  - Dependencies: Tasks 1.1-1.3

## Epic 2: Research & Decision Support
- [x] Task 2.1: Jackett vs Prowlarr comparison
  - Objective: Evaluate stability, API ergonomics, ops burden, community, fit.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Decision Brief section with citations and recommendation.
  - Owner Agent: Librarian
  - Tooling: websearch_exa_web_search_exa, webfetch
  - Dependencies: Task 1.4
- [x] Task 2.2: Indexer stack strategy
  - Objective: Define public/semi/private coverage strategy with cost minimization.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Decision Brief section with tiered strategy.
  - Owner Agent: Librarian
  - Tooling: websearch_exa_web_search_exa
  - Dependencies: Task 1.4
- [x] Task 2.3: Autosub improvement options
  - Objective: Identify reliable subtitle tooling and best practices.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Decision Brief section with options and tradeoffs.
  - Owner Agent: Librarian
  - Tooling: websearch_exa_web_search_exa, webfetch
  - Dependencies: Task 1.4
- [x] Task 2.4: Produce Decision Brief artifact
  - Objective: Consolidate research into a decision-ready brief.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Decision Brief in repo with citations and recommendation.
  - Owner Agent: Sisyphus
  - Tooling: write
  - Dependencies: Tasks 2.1-2.3

## Epic 3: Interrogation & Preferences (STOP PHASE)
- [x] Task 3.1: Run preferences workshop (blocking)
  - Objective: Ask required preference questions and capture answers.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): User answers recorded; TODOs updated.
  - Owner Agent: Sisyphus
  - Tooling: todowrite, write
  - Dependencies: Task 2.4

## Epic 4: Reboot Implementation (POST-ANSWERS ONLY)
- [x] Task 4.1: Implement indexer manager and strategy
  - Objective: Integrate chosen indexer tool and tiered config.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Working integration with docs and config examples.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics
  - Dependencies: Task 3.1
- [x] Task 4.2: Implement autosub improvements
  - Objective: Improve subtitle reliability and fallback behavior.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Updated autosub path with tested behavior.
  - HANG ROOT CAUSE: `utils.subprocess` calls to `subliminal` have no timeouts or attempt limits; can block indefinitely on network/provider issues.
  - EVIDENCE: Validated `timeout` command availability and exit code 124. Implemented `run_with_timeout` wrapper in `autosub.lua` with 20s timeout and 2 retries.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics
  - Dependencies: Task 3.1
- [x] Task 4.3: Redesign CLI UX per preferences
  - Objective: Update CLI commands, flags, and interactive behavior.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): CLI flow aligned with preferences; help/usage updated.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics
  - Dependencies: Task 3.1

## Epic 5: Data Hardening
- [x] Task 5.1: Input validation and error handling
  - Objective: Validate inputs, add safe error handling and retries.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): No obvious crash paths; meaningful errors.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics
  - Dependencies: Tasks 4.1-4.3
- [x] Task 5.2: Config persistence safeguards
  - Objective: Ensure config stored safely and portably.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Config behavior documented and tested.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics
  - Dependencies: Tasks 4.1-4.3
- [x] Task 5.3: Tests and logging
  - Objective: Add/adjust tests and logging defaults.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Tests pass; logging is actionable.
  - Owner Agent: Sisyphus
  - Tooling: read, edit, lsp_diagnostics, bash
  - Dependencies: Tasks 4.1-4.3

## Epic 6: Finalization
- [x] Task 6.1: Docs update
  - Objective: Update README and usage examples.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): README reflects new workflows.
  - Owner Agent: Sisyphus
  - Tooling: read, edit
  - Dependencies: Tasks 4.1-5.3
- [x] Task 6.2: Verify and clean history
  - Objective: Ensure TODOs complete, tests pass, clean git history.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): All tasks checked; clean working tree.
  - Owner Agent: Sisyphus
  - Tooling: bash, todowrite
  - Dependencies: Tasks 4.1-6.1
- [x] Task 6.3: Push final product
  - Objective: Push clean commits to remote.
  - Acceptance Criteria (requirements: free-only indexers; interactive-first UX; English subtitles with OpenSubtitles.com priority + auto-fallback; unified XDG-style config; clear readable logs): Remote updated; final status reported.
  - Owner Agent: Sisyphus
  - Tooling: bash
  - Dependencies: Task 6.2

## Current State Report
- CLI entrypoint: `bin/cine` (bash)
  - Actions: new search, resume history, stream or download.
  - History log: `~/.local/share/cine-cli/history.jsonl`.
  - Jackett API key: `~/.config/Jackett/ServerConfig.json`.
  - Search endpoint: `http://127.0.0.1:9117/api/v2.0/indexers/all/results`.
- Indexer integration: Jackett systemd user service in `systemd/jackett.service`.
- Autosub integration: MPV Lua script `config/mpv/scripts/autosub.lua`.
  - Invokes `subliminal download` via `mp.utils.subprocess`.
  - Default config: `~/.config/subliminal/subliminal.toml`.
  - Skips web streams unless localhost (path check in autosub).
- Subliminal configuration template: `config/subliminal/subliminal.toml.template`.
- MPV config: `config/mpv/mpv.conf`, webtorrent opts in `config/mpv/script-opts/webtorrent.conf`.

## Decision Brief

## Architecture Notes (Oracle)
- Structure: core (config/state/logging/retry/ui), adapters (indexers/subtitles/player), commands (orchestration).
- XDG layout: config `~/.config/cine/`, state `~/.local/state/cine/`, cache `~/.cache/cine/`, logs under state.
- Indexer strategy: keep Jackett adapter; normalize results; free-only filters; clear provider errors.
- Autosub: OpenSubtitles.com priority, fallback chain; prompt on low-confidence matches.
- Logging: console concise, file logs structured with run_id/phase; retries with backoff for idempotent ops.

## UX Notes
- Interactive-first flow; allow `cine "query"` to skip initial prompt.
- Use fzf bindings: Enter=stream, Ctrl+D=download, Ctrl+Y=copy magnet.
- Show all results and filter interactively (no pre-filter gate); include quality/size/seeds columns.
- Soft-land on no results: re-prompt without exiting.

### Jackett vs Prowlarr (for cine-cli)
- Recommendation: Keep Jackett for now (simpler Torznab integration; higher indexer coverage for standalone CLI).
- Rationale: cine-cli uses Jackett's Torznab JSON endpoint already; minimizing refactors keeps behavior stable.
- Risks:
  - Jackett API key rotation after crashes; mitigate by supporting env override and clear error messages.
  - Indexer breakage due to tracker changes; mitigate with quick upgrades and a provider abstraction.
- Sources:
  - https://github.com/Jackett/Jackett
  - https://github.com/Prowlarr/Prowlarr
  - https://www.libhunt.com/compare-Prowlarr-vs-Jackett
  - https://shareconnector.net/prowlarr-vs-jackett/

### Indexer stack strategy
- Default posture: public-first indexers for baseline coverage; allow free semi-private only if no paid subscription or login required by default.
- No existing accounts assumed; private trackers disabled unless user explicitly adds credentials later.
- Limit scope using Torznab category IDs for Movies/TV (e.g., 2000/5000 families) to avoid irrelevant results and reduce load.
- Trackers require frequent updates; prefer actively maintained indexer definitions and keep Jackett updated.
- Sources:
  - https://docs.searxng.org/dev/engines/online/torznab.html
  - https://github.com/Jackett/Jackett/wiki/Jackett-Categories
  - https://docs.ultra.cc/applications/jackett

### Autosub improvement options
- Prioritize OpenSubtitles.com; auto-fallback to free sources in order.
- Recommended free provider order (English): opensubtitlescom → podnapisi → tvsubtitles → addic7ed (only if user adds free account).
- OpenSubtitles.com free tier: 5/day anonymous, 20/day with free account; plan for rate limits.
- Keep Subliminal CLI with TOML config; tune `min_score`/`language`/`refiner`; use `--age` to avoid bans.
- Sources:
  - https://subliminal.readthedocs.io/en/latest/user/cli.html
  - https://subliminal.readthedocs.io/en/latest/user/usage.html
  - https://opensubtitles.tawk.help/article/about-the-api
  - https://www.podnapisi.net
  - https://www.tvsubtitles.net

