#!/usr/bin/env bash
set -e

# describe Analyze disk usage for a filesystem path
# @arg path! The filesystem path to analyze
# @option --limit=10 Maximum number of items to return

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  du ${argc_path} | head -n $argc_limit >$LLM_OUTPUT
}

eval "$(argc --argc-eval "$0" "$@")"
