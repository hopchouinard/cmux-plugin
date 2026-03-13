# Changelog

All notable changes to the cmux Claude Code plugin will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

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
