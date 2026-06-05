---
description: Show current cmux workspace context — workspaces, panes, surfaces, and sidebar state. Useful for orientation when managing multiple parallel tasks.
---

Check if we're inside cmux, then show the full current context:

1. Run `cmux identify --json` to get current workspace, pane, and surface IDs
2. Run `cmux list-workspaces` to show all open workspaces and their names
3. Run `cmux list-panes` to show current split layout
4. Run `cmux list-log` to show recent sidebar entries

Present the results as a clean summary showing what's open, what's active,
and any recent sidebar log messages. If not inside cmux, say so clearly.
