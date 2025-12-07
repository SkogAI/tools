#!/usr/bin/env bash

# @describe Parse input text using skogparse and return the output
# @option --input! The text to parse with skogparse

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  skogparse "$argc_input" >>"$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
