#!/usr/bin/env bash
set -e

# @describe Manages a Claude context file
# @arg context-file! Path to the Claude context file
# @env SKOGAI_DOT_FOLDER Required environment variable for script paths

main() {
  local context_file="$argc_context-file"

  if [ -z "$SKOGAI_DOT_FOLDER" ]; then
    echo "Error: SKOGAI_DOT_FOLDER environment variable is not set."
    exit 1
  fi

  $SKOGAI_DOT_FOLDER/scripts/context-start.sh "$context_file"
  cat "./$context_file.md"
  $SKOGAI_DOT_FOLDER/scripts/context-end.sh "$context_file"
}

eval "$(argc --argc-eval "$0" "$@")"
