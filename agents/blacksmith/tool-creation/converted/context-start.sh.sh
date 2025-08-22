#!/usr/bin/env bash
set -e

# @describe Generates a timestamped context string
# @arg context! The context to include in the output
# @env DATE_FORMAT Optional format for the date (default: %Y-%m-%d %H:%M:%S)

main() {
  local context="$argc_context"
  local date_format="${DATE_FORMAT:-%Y-%m-%d %H:%M:%S}"

  printf "\n[@claude:context:%s]\n(generated: $(date +"$date_format"))\n" "$context"
}

eval "$(argc --argc-eval "$0" "$@")"
