#!/usr/bin/env bash
set -e

# @describe Creates release branch and .llm directory structure
# @arg version! Release version number
# @env DEBUG Set to enable debug output

main() {
    local version="$argc_version"
    
    # start git-flow release
    "$(dirname "$0")/git/release-start.sh" "$version"
    
    # create .llm documentation structure
    "$(dirname "$0")/llm/release-start.sh" "$version"
    
    echo "Release workflow complete for $version"
}

eval "$(argc --argc-eval "$0" "$@")"
</output>

