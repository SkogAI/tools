#!/usr/bin/env bash

# @describe Manage context by executing scripts and displaying README file
# @arg script! Script to execute
# @env SKOGAI_DOT_FOLDER Directory containing script and README file

context_start() {
  local script="$1"
  echo "Starting context for $script..."
}

context_end() {
  local script="$1"
  echo "Ending context for $script..."
}

main() {
  local script="$argc_script"

  context_start "$script"
  cat "$SKOGAI_DOT_FOLDER/readme.md"
  context_end "$script"
}

eval "$(argc --argc-eval "$0" "$@")"
