#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path
# @env SKOGAI=/home/skogix/skogai SkogAI root dir

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DOCS_DIR="/home/skogix/skogai/docs"

# @cmd Show statistics about documentation
# @option --doc-path Path to document relative to docs/ (optional, shows all if omitted)
doc_stats() {
  if [[ -n "$argc_doc_path" ]]; then
    # Stats for specific document
    local doc_file="$DOCS_DIR/$argc_doc_path"

    if [[ ! -f "$doc_file" ]]; then
      echo "Error: Document not found: $doc_file" >>"$LLM_OUTPUT"
      return 1
    fi

    {
      echo "=== Statistics for $argc_doc_path ==="
      echo

      local line_count=$(wc -l <"$doc_file")
      local word_count=$(wc -w <"$doc_file")
      local header_count=$(grep -c -E "^#{1,6} " "$doc_file" 2>/dev/null || echo 0)
      local code_block_count=$(grep -c "^\`\`\`" "$doc_file" 2>/dev/null || echo 0)
      code_block_count=$((code_block_count / 2)) # Divide by 2 for opening/closing pairs

      echo "Line count:       $line_count"
      echo "Word count:       $word_count"
      echo "Header count:     $header_count"
      echo "Code blocks:      $code_block_count"
    } >>"$LLM_OUTPUT"
  else
    # Stats for all documentation
    {
      echo "=== Documentation Statistics for $DOCS_DIR ==="
      echo

      local total_files=$(find "$DOCS_DIR" -type f | wc -l)
      local md_files=$(find "$DOCS_DIR" -type f -name "*.md" | wc -l)
      local total_dirs=$(find "$DOCS_DIR" -type d | wc -l)

      echo "Total files:      $total_files"
      echo "Markdown files:   $md_files"
      echo "Directories:      $total_dirs"
      echo

      if [[ $md_files -gt 0 ]]; then
        echo "=== Markdown File Statistics ==="
        local total_lines=0
        local total_words=0

        while IFS= read -r file; do
          total_lines=$((total_lines + $(wc -l <"$file")))
          total_words=$((total_words + $(wc -w <"$file")))
        done < <(find "$DOCS_DIR" -type f -name "*.md")

        echo "Total lines:      $total_lines"
        echo "Total words:      $total_words"
      fi
    } >>"$LLM_OUTPUT"
  fi
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
