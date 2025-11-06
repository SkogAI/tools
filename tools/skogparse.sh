#!/usr/bin/env bash
set -e

# @describe Parse input text using skogparse and return the output
# @option --input! The input text to parse with skogparse

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
    # Run skogparse with the input and send output to LLM_OUTPUT
    skogparse "$argc_input" >> "$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
