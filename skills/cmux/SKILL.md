---
name: cmux
description: Use cmux terminal features when running inside cmux. Detected via CMUX_WORKSPACE_ID environment variable. Apply proactively for parallel work (worktrees, sub-agents, long tasks), browser-based testing, sidebar progress reporting, and attention notifications. Do NOT apply when not inside cmux.
---

# cmux Terminal Integration

cmux is a native macOS terminal built for AI coding agents. When running inside it
you have access to a CLI that lets you control workspace layout, report progress in
the sidebar, open a scriptable browser pane, and send notifications.

## Detection — Always Check First

Before using any cmux feature, confirm you are inside cmux:

```bash
[ -n "$CMUX_WORKSPACE_ID" ] \
  && [ -n "$CMUX_SURFACE_ID" ] \
  && [ -S "${CMUX_SOCKET_PATH:-/tmp/cmux.sock}" ] \
  && command -v cmux &>/dev/null
```

If any check fails → skip all cmux commands silently. Never error because cmux is absent.

Quick orientation when inside cmux:

```bash
cmux identify --json     # Current window / workspace / pane / surface IDs
cmux list-workspaces     # All open workspaces
```

## Hierarchy

```
Window
  └── Workspace  (sidebar tab — one per project or parallel task)
        └── Pane  (split region — horizontal or vertical)
              └── Surface  (terminal or browser session)
```

Refer to them as `workspace:1`, `pane:2`, `surface:3` in CLI commands.

---

## When to Use Each Feature

### New workspace — parallel and isolated work

**Trigger:** About to create a git worktree, launch an independent sub-agent on a
separate branch, or start a task that is genuinely isolated from the current context.

```bash
# Create a named workspace for the new branch / task
cmux new-workspace --name "feature/auth"

# Or rename current workspace to match what you're about to do
cmux rename-workspace "$CMUX_WORKSPACE_ID" "feature/auth"
```

**Restraint:** One workspace per isolated worktree or major parallel thread.
Do NOT open a new workspace for every subtask within a single feature.

---

### Browser split — visual and DOM verification

**Trigger:** Need to verify a UI, test a dev server, check rendered output,
debug a CSS issue, or interact with a running app.

```bash
# Open a browser to the right of the current terminal pane
cmux browser surface:$CMUX_SURFACE_ID open-split --direction right
sleep 1

# Navigate
cmux browser surface:2 navigate "http://localhost:3000"

# Inspect and interact
cmux browser surface:2 snapshot --compact                    # Read DOM
cmux browser surface:2 get text ".error-message"            # Extract text
cmux browser surface:2 click "button.submit"                # Click element
cmux browser surface:2 fill "#search" "query"               # Type into field
cmux browser surface:2 screenshot --out /tmp/verify.png     # Capture screenshot
```

**Restraint:** Only open a browser split when visual/DOM verification is genuinely
needed. Close the surface when done — don't leave idle browser panes open.

---

### Sidebar progress — long-running tasks

**Trigger:** Any task that will take more than ~30 seconds. Set a bar at the start,
update it as stages complete, clear it when done.

```bash
cmux log --level info --source "claude" "Starting: full test suite..."
cmux set-progress 0.0

# Update as work proceeds
cmux set-progress 0.25
cmux log --level progress --source "claude" "Tests: 40/150 passing"

cmux set-progress 0.75
cmux log --level progress --source "claude" "Tests: 112/150 passing"

# Completion
cmux set-progress 1.0
cmux log --level success --source "claude" "All 150 tests passed ✓"
cmux clear-progress
```

Sidebar log levels: `info` · `progress` · `success` · `warning` · `error`

---

### Notifications — genuine handoff points

**Trigger:** A long sub-agent task has finished and needs human review.
You have reached a checkpoint and are waiting for human input.

```bash
cmux notify --title "Claude Code" --body "Sub-agent finished: auth feature ready for review"
cmux notify --title "Claude Code" --subtitle "Checkpoint" --body "Plan approved — ready to execute"

# Flash the pane ring to grab visual attention
cmux flash-pane
```

**Restraint:** Do NOT notify after every small step. Reserve notifications for real
handoff moments where you genuinely need the human's eyes.

---

## Superpowers Plugin Integration

When the Superpowers plugin is active and its workflows trigger:

| Superpowers event | cmux action |
|---|---|
| `using-git-worktrees` activates | Open new workspace named after the branch |
| `subagent-driven-development` running | Set + update progress bar per task completed |
| Each sub-agent task completes | `cmux log --level success` with task name |
| `finishing-a-development-branch` activates | `cmux notify` — human review needed |

This gives ambient awareness of parallel work across the sidebar without the human
needing to actively watch any terminal.

---

## Full CLI Reference

```bash
# Workspace
cmux list-workspaces
cmux new-workspace --name "label"
cmux rename-workspace <id> "new-name"
cmux switch-workspace <id>
cmux close-workspace <id>

# Panes and surfaces
cmux list-panes
cmux new-pane --direction right|left|up|down
cmux list-surfaces
cmux focus-surface <id>

# Browser
cmux browser <surface-id> open-split --direction right|left|up|down
cmux browser <surface-id> navigate "<url>"
cmux browser <surface-id> snapshot --compact
cmux browser <surface-id> get text "<css-selector>"
cmux browser <surface-id> click "<css-selector>"
cmux browser <surface-id> fill "<css-selector>" "<value>"
cmux browser <surface-id> screenshot --out <path>

# Sidebar
cmux log --level info|progress|success|warning|error --source "<label>" "<message>"
cmux set-progress <0.0–1.0>
cmux clear-progress
cmux list-logs
cmux clear-logs

# Notifications
cmux notify --title "<title>" --body "<body>"
cmux notify --title "<title>" --subtitle "<subtitle>" --body "<body>"
cmux flash-pane

# System
cmux ping
cmux identify --json
cmux capabilities
```

---

## Rules

- **Always detect** before using. Never assume you're in cmux.
- **New workspace** for parallel/isolated work only. Not for subtasks.
- **Browser split** for visual/DOM verification only. Close when done.
- **Progress bar** for tasks over ~30 seconds.
- **Notify** at genuine handoff points only — not after every step.
- **Never crash** if cmux is absent. All cmux calls are best-effort, exit 0.
