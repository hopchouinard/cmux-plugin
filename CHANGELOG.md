# Changelog

All notable changes to the cmux Claude Code plugin will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [1.0.1] — 2026-03-12

### Fixed
- `plugin.json`: `author` must be an object, not a string; removed unsupported `requirements` key
- Restructured repo as a proper marketplace with the plugin in a `cmux/` subdirectory
- `hooks.json`: hook entries must be objects with `type`/`command` fields, not bare strings; use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- `SKILL.md`: aligned CLI reference with actual cmux commands (`list-logs` → `list-log`, `flash-pane` → `trigger-flash`, `switch-workspace` → `select-workspace`, corrected flag syntax)
- `commands/status.md`: corrected `list-logs` → `list-log`
- `cmux-session-start.sh`: fixed `rename-workspace` to use `--workspace` flag (was silently failing)

### Added
- `marketplace.json` for plugin registry support
- Sidebar status metadata commands in SKILL.md (`set-status`, `clear-status`, `list-status`, `sidebar-state`)

---

## [1.0.0] — 2026-03-12

### Added
- `SessionStart` hook: auto-renames cmux workspace tab to git repo name + branch
- `Stop` hook: cmux notification when Claude session completes
- `PostToolUse(Task)` hook: cmux notification when sub-agent finishes
- `skills/cmux/SKILL.md`: teaches Claude when and how to use all cmux features
- Superpowers plugin integration guidance in skill (worktrees → new workspace, subagent-driven-development → progress bar, finishing-a-development-branch → notification)
- `/cmux:status` slash command — orientation view of current workspace state
- `/cmux:open-browser` slash command — open browser split for dev server verification
- Silent no-op behavior when not running inside cmux (guards on `CMUX_WORKSPACE_ID` and socket path)
