#!/usr/bin/env bash
set -e

# @describe finish git-flow release and cleanup .llm documentation structure
# @env DEBUG Set to enable debug output

main() {
    # finish git-flow release (auto-detects current release)
    "$(dirname "$0")/git/release-finish.sh"

    # cleanup .llm documentation structure (auto-detects current release)
    "$(dirname "$0")/llm/release-finish.sh"

    echo "Release workflow complete"
}

eval "$(argc --argc-eval "$0" "$@")"

