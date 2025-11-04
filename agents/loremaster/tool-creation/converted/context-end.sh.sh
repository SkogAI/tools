#!/usr/bin/env bash
set -e

# @describe Prints a personalized context message
# @arg 1! Context to display

main() {
  local context="$argc_1"

  printf "[@/claude:context:%s]\n" "$context"
}

eval "$(argc --argc-eval "$0" "$@")"
