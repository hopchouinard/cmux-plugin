#!/bin/bash
# cmux-notify.sh
# Fires on Claude Code Stop and PostToolUse(Task) events.
# Sends a cmux notification so you know when Claude or a sub-agent
# has finished and needs your attention.
#
# Silently exits if not running inside cmux.

# ── Guard ──────────────────────────────────────────────────────────────────────
[ -S "${CMUX_SOCKET_PATH:-/tmp/cmux.sock}" ] || exit 0
command -v cmux &>/dev/null                  || exit 0
command -v jq   &>/dev/null                  || exit 0

# ── Parse event ───────────────────────────────────────────────────────────────
EVENT=$(cat)
EVENT_TYPE=$(echo "$EVENT" | jq -r '.hook_event_name // .event // "unknown"')
TOOL=$(echo "$EVENT"       | jq -r '.tool_name // ""')

# ── Notify by event type ───────────────────────────────────────────────────────
case "$EVENT_TYPE" in
    "Stop")
        cmux notify \
            --title "Claude Code" \
            --body  "Session complete — ready for your review" \
            2>/dev/null
        ;;
    "PostToolUse")
        if [ "$TOOL" = "Task" ]; then
            cmux notify \
                --title "Claude Code" \
                --subtitle "Sub-agent" \
                --body  "Agent finished — check results" \
                2>/dev/null
        fi
        ;;
esac

exit 0
