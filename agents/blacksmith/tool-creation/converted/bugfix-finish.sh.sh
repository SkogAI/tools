#!/usr/bin/env bash
set -e

# @describe Finishes bugfix branch and merges to develop
# @arg name! Name of the bugfix branch to finish
# @env DEBUG Set to enable debug output

main() {
  # Finish git-flow bugfix
  "$SKOGAI_DOT_FOLDER/scripts/git/bugfix-finish.sh" "$argc_name"

  echo "Bugfix workflow complete for $argc_name"
}

eval "$(argc --argc-eval "$0" "$@")"
