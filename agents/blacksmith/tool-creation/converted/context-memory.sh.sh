#!/usr/bin/env bash
set -e
"$SKOGAI_DOT_FOLDER"/scripts/context-start.sh "memory"

# maybe change for todo?
# # check if Basic Memory is available via MCP
# if command -v memory >/dev/null 2>&1; then
#     echo "## Recent Memory Activity"
#     memory recent --limit 5 2>/dev/null || echo "Memory system unavailable"
#     echo
#     echo "## Memory Projects"
#     memory projects 2>/dev/null || echo "No memory projects found"
# else
#     echo "## Memory Context"
#     echo "Basic Memory not available - check MCP configuration"
# fi

"$SKOGAI_DOT_FOLDER"/scripts/context-end.sh "memory"
