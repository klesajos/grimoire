#!/usr/bin/env bash
# Example hook script — a "ward". Fires on SessionStart once hooks/hooks.json
# is active (rename hooks/hooks.json.example -> hooks/hooks.json to activate).
#
# Anything printed to stdout from a SessionStart hook is added to Claude's
# context for the session. Keep it short. A real ward might run a linter,
# inject project conventions, or block on a dirty git tree.
#
# Remember: chmod +x this file, or the hook silently fails to execute.

echo "🪄 starter-spell ward fired — plugin hooks are working."
