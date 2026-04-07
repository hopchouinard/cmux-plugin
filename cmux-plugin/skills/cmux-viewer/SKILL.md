---
name: cmux-viewer
description: Open files for viewing in cmux panes. Use when user asks to see, view, preview, or open a file for reading. Auto-detect file type and choose the right viewer.
---

# cmux File Viewer

When the user wants to view a file, open it in a cmux pane using the appropriate viewer.

## Detection — Always Check First

Before using any viewer, confirm you are inside cmux:

```bash
[ -n "$CMUX_WORKSPACE_ID" ] \
  && [ -S "${CMUX_SOCKET_PATH:-/tmp/cmux.sock}" ] \
  && command -v cmux &>/dev/null
```

If any check fails → fall back to terminal-only viewing (cat/less). Never error because cmux is absent.

## File Type → Viewer

| Extension | Viewer | Command |
|-----------|--------|---------|
| `.md` | cmux Markdown Viewer | `cmux markdown open <path>` |
| Code files (`.py`, `.js`, `.ts`, `.rs`, `.go`, `.sh`, `.json`, `.yaml`, `.toml`, etc.) | nvim in split pane | See below |
| `.html` | cmux browser pane | `cmux new-pane --type browser --url file://<path>` |

## Opening Markdown

```bash
cmux markdown open <path>
```

Native rendering with live reload — file changes are reflected automatically.

## Opening Code

```bash
# 1. Create a split pane
cmux new-pane --direction right
# Note the surface ID from the output (e.g. surface:5)

# 2. Open file in nvim
cmux send --surface <surface> "nvim <path>"
cmux send-key --surface <surface> Enter
```

nvim provides:
- Syntax highlighting for all common languages
- Auto-reflow when pane is resized
- Line numbers
- Editable (unlike bat/cat)

## Opening Web Content

```bash
cmux new-pane --type browser --url <url>
```

## Fallbacks

If nvim is not installed, fall back to `less <path>` (paging, no highlighting).
If cmux is not available, fall back to `cat -n <path>`.

## Verification

After opening a pane, verify it rendered correctly:

```bash
cmux capture-pane --surface <surface> | tail -5
```

## Rules

- **Always** use `cmux markdown open` for `.md` files
- **Always** use `nvim` for code files — it reflows with pane resize
- **Never** use `bat` for viewing in panes — it doesn't reflow on resize
- **Never** use `cat` when cmux is available — no highlighting, no paging
- **Close** viewer panes when the user is done reviewing
