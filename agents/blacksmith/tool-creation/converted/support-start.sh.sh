#!/usr/bin/env bash
set -e

# @describe Creates a support branch for long-term maintenance
# @arg name! Name of the support branch to create
# @env DEBUG Set to enable debug output

main() {
  local name="$argc_name"

  # Check if git-flow support script exists
  if [ ! -f "$SKOGAI_DOT_FOLDER/scripts/git/support-start.sh" ]; then
    echo "Error: Support script not found!"
    exit 1
  fi

  # Execute git-flow support start script
  "$SKOGAI_DOT_FOLDER/scripts/git/support-start.sh" "$name"

  # Show some info
  if [ -n "$DEBUG" ]; then
    echo "Support workflow started for $name"
  fi
}

eval "$(argc --argc-eval "$0" "$@")"
