#!/usr/bin/env bash
set -e

# @describe Creates bugfix branch for bug fixes
# @arg name! Name of the bugfix branch
# @env DEBUG Set to enable debug output

main() {
    local name="$argc_name"
    
    # start git-flow bugfix
    "$(dirname "$0")/git/bugfix-start.sh" "$name"

    echo "Bugfix workflow started for $name"
}

eval "$(argc --argc-eval "$0" "$@")"

