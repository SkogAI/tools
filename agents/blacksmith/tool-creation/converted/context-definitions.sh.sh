#!/usr/bin/env bash
set -e

# @describe Manages context and displays definitions
# @env SKOGAI_DOT_FOLDER Path to the dot folder containing scripts and documents

main() {
  local script_folder="$SKOGAI_DOT_FOLDER/scripts"
  local doc_folder="$SKOGAI_DOT_FOLDER/docs"

  # Start context
  $script_folder/context-start.sh "definitions"

  # Display definitions
  cat "$doc_folder/definitions.md"

  # End context
  $script_folder/context-end.sh "definitions"
}

eval "$(argc --argc-eval "$0" "$@")"
