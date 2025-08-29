#!/usr/bin/env bash

# @describe SkogAI context generation
# @meta version 1.0.0
# @meta dotenv
# @env ISSKOGIXBEST=yes

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# @cmd SkogAI
main() {
  skogparse '[@argc]'
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
