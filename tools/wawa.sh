#!/usr/bin/env bash
set -e

# @describe wawaa

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
  argc --argc-run /home/skogix/skogai/skogargc/docs/skogix.sh "$FUNCNAME" "${argc_args[@]}" >$LLM_OUTPUT
}

eval "$(argc --argc-eval "$0" "$@")"
