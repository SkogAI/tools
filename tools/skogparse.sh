#!/usr/bin/env bash
set -e

# @describe Parse input text using skogparse and return the output

# @env LLM_OUTPUT=/dev/stdout The output path
# @option --text! The text to parse with skogparse

main() {
  # Run skogparse with the text and send output to LLM_OUTPUT
  skogparse $argc_text >>"$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
