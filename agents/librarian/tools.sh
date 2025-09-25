#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path
# @env SKOGAI=/home/skogix/skogai SkogAI root dir

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# @cmd Create a new file at the specified path with contents.
# @option --path! The path where the file should be created
# @option --contents! The contents of the file
fs_create() {
  "$ROOT_DIR/utils/guard_path.sh" "$argc_path" "Create '$argc_path'?"
  mkdir -p "$(dirname "$argc_path")"
  printf "%s" "$argc_contents" >"$argc_path"
  echo "File created: $argc_path" >>"$LLM_OUTPUT"
}

# @cmd Show the library
show_library() {
  local library="$SKOGAI/docs/"
  tree -C "$library/archives" "$library/official" --noreport >>"$LLM_OUTPUT"
}

# @cmd Read official SkogAI documents from the official documentation directory
# @option --document! The name or path of the official document to read (use "list" to see all)
read_official_documents() {
  local official_dir="/home/skogix/skogai/docs/official"

  if [[ "$argc_document" == "list" ]]; then
    ls -la "$official_dir" >>"$LLM_OUTPUT"
  else
    cat "$official_dir/$argc_document" >>"$LLM_OUTPUT" 2>/dev/null ||
      cat "$official_dir/$argc_document.md" >>"$LLM_OUTPUT"
  fi
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
