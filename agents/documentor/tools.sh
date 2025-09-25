#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path
# @env SKOGAI=/home/skogix/skogai SkogAI root dir

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

generate_doc_recommendations() {
  echo "- Consider adding more detailed examples" >$LLM_OUTPUT
  echo "- Improve section organization and hierarchy" >>$LLM_OUTPUT
  echo "- Add cross-references between related documents" >>$LLM_OUTPUT
  echo "- Include troubleshooting sections" >>$LLM_OUTPUT
  echo "- Update outdated information" >>$LLM_OUTPUT
}

# @cmd Show the library
show_library() {
  local library="$SKOGAI/docs/"
  tree -C "$library/archives" "$library/official" --noreport >>"$LLM_OUTPUT"
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
