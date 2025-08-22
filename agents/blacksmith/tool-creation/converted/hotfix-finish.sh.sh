#!/usr/bin/env bash
set -e

# @describe Finishes hotfix branch and merges to master/develop
# @arg name! Name of the hotfix branch to finish
# @env DEBUG Set to enable debug output

main() {
    local name="$argc_name"
    
    # Finish git-flow hotfix
    "$(dirname "$0")/git/hotfix-finish.sh" "$name"

    if [ -n "$DEBUG" ]; then
        echo "Hotfix workflow complete for $name"
    fi
}

eval "$(argc --argc-eval "$0" "$@")"


