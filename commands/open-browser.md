---
description: Open a browser split pane alongside the current terminal and navigate to the dev server or a specified URL. Use for visual verification of UI, debugging layout issues, or testing a running app. Arguments: optional URL (defaults to http://localhost:3000).
---

Open a cmux browser split for visual verification.

1. Check we're inside cmux — if not, explain that this requires cmux and stop
2. Get current surface ID from `cmux identify --json`
3. Open a browser split to the right: `cmux browser surface:<id> open-split --direction right`
4. Wait 1 second for the split to initialize
5. Navigate to: $ARGUMENTS (if provided) or http://localhost:3000 (default)
   `cmux browser surface:2 navigate "<url>"`
6. Take a snapshot to confirm the page loaded: `cmux browser surface:2 snapshot --compact`
7. Report what you see — page title, any visible errors, key UI elements

If $ARGUMENTS contains a specific element to check (e.g. "localhost:8080 check the nav"),
extract both the URL and the intent and act accordingly.
