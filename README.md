# cmux — Claude Code Plugin

Integrates [Claude Code](https://claude.ai/code) with [cmux](https://www.cmux.dev) — the native macOS terminal built for AI coding agents.

## What It Does

| Feature | How it works |
|---|---|
| **Auto workspace naming** | `SessionStart` hook renames the cmux sidebar tab to your git repo name + branch on every session |
| **Completion notifications** | `Stop` and sub-agent `Task` hooks fire cmux notifications so you know when Claude or a sub-agent needs your attention |
| **Sidebar progress** | The cmux skill teaches Claude to report long-running task progress as a live progress bar in the sidebar |
| **Browser split automation** | Claude proactively opens a browser split when it needs to visually verify your dev server or debug UI |
| **Superpowers integration** | When the [Superpowers plugin](https://claude.com/plugins/superpowers) triggers `using-git-worktrees`, Claude opens a new cmux workspace for the branch automatically |
| **Slash commands** | `/cmux:status` and `/cmux:open-browser` for manual control |

## Requirements

- macOS 14.0+
- [cmux](https://www.cmux.dev) installed (`brew tap manaflow-ai/cmux && brew install --cask cmux`)
- cmux CLI symlinked: `sudo ln -sf "/Applications/cmux.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux`
- `jq` installed (`brew install jq`)

## Installation

```bash
# In Claude Code
/plugin marketplace add hopchouinard/patchoutech-plugins
/plugin install cmux@patchoutech-plugins
/reload-plugins
```

## Slash Commands

| Command | Description |
|---|---|
| `/cmux:status` | Show current workspace, panes, surfaces, and sidebar log |
| `/cmux:open-browser [url]` | Open a browser split (defaults to `localhost:3000`) |

## How Claude Uses cmux Automatically

Claude detects cmux via the `CMUX_WORKSPACE_ID` environment variable. If it's not set (i.e. you're not in cmux), all cmux features are silently skipped — this plugin causes zero noise in other environments.

When inside cmux, Claude will:

- **Open a new workspace** when about to create a git worktree or launch an independent sub-agent
- **Maintain a progress bar** in the sidebar during tasks that take more than ~30 seconds
- **Open a browser split** when it needs to visually verify UI or test a dev server
- **Send a notification** at genuine handoff points — not after every step

## Works With Superpowers

If you have the [Superpowers plugin](https://claude.com/plugins/superpowers) installed, the cmux skill is aware of its workflow phases:

- `using-git-worktrees` → new cmux workspace named after the branch
- `subagent-driven-development` → live progress bar per task
- `finishing-a-development-branch` → notification that review is ready

## File Structure

```
cmux-plugin/
├── .claude-plugin/
│   └── marketplace.json       # Marketplace manifest
├── cmux/
│   ├── .claude-plugin/
│   │   └── plugin.json        # Plugin manifest
│   ├── skills/
│   │   └── cmux/
│   │       └── SKILL.md       # Core skill — teaches Claude when/how to use cmux
│   ├── hooks/
│   │   └── hooks.json         # Hook event declarations
│   ├── scripts/
│   │   ├── cmux-session-start.sh  # Renames workspace tab on session start
│   │   └── cmux-notify.sh         # Sends notifications on Stop / sub-agent finish
│   └── commands/
│       ├── status.md          # /cmux:status
│       └── open-browser.md    # /cmux:open-browser
├── CHANGELOG.md
└── README.md
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT — see [LICENSE](LICENSE).

## Author

Patrick Chouinard ([@hopchouinard](https://github.com/hopchouinard))  
AI Acceleration Specialist · [Wepoint](https://wepoint.ca)
