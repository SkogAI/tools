#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path
# @env SKOGAI=/home/skogix/skogai SkogAI root dir

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DOCS_DIR="/home/skogix/skogai/docs"

# @cmd Create a new file at the specified path with contents.
# @option --path! The path where the file should be created
# @option --contents! The contents of the file
fs_create() {
  "$ROOT_DIR/utils/guard_path.sh" "$argc_path" "Create '$argc_path'?"
  mkdir -p "$(dirname "$argc_path")"
  printf "%s" "$argc_contents" >"$argc_path"
  echo "File created: $argc_path" >>"$LLM_OUTPUT"
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

# @cmd List all documentation files with optional filtering
# @option --pattern File pattern to match (e.g., "*.md", "argc*")
# @option --type[files|dirs|all] What to list (default: files)
# @flag --recursive Include subdirectories
list_docs() {
  local type="${argc_type:-files}"
  local pattern="${argc_pattern:-*}"

  {
    echo "=== Documentation Files in $DOCS_DIR ==="
    echo

    if [[ "$argc_recursive" == "1" ]]; then
      case "$type" in
        files)
          find "$DOCS_DIR" -type f -name "$pattern" | sort
          ;;
        dirs)
          find "$DOCS_DIR" -type d -name "$pattern" | sort
          ;;
        all)
          find "$DOCS_DIR" -name "$pattern" | sort
          ;;
      esac
    else
      case "$type" in
        files)
          find "$DOCS_DIR" -maxdepth 1 -type f -name "$pattern" | sort
          ;;
        dirs)
          find "$DOCS_DIR" -maxdepth 1 -type d -name "$pattern" | sort
          ;;
        all)
          find "$DOCS_DIR" -maxdepth 1 -name "$pattern" | sort
          ;;
      esac
    fi

    echo
    echo "Use --recursive to include subdirectories"
  } >>"$LLM_OUTPUT"
}

# @cmd Show summary of a document (first N lines + last 10 lines)
# @option --doc-path! Path to document relative to docs/
# @option --lines <INT> Number of preview lines from start (default: 20)
summarize_doc() {
  local doc_file="$DOCS_DIR/$argc_doc_path"
  local preview_lines="${argc_lines:-20}"

  if [[ ! -f "$doc_file" ]]; then
    echo "Error: Document not found: $doc_file" >>"$LLM_OUTPUT"
    return 1
  fi

  {
    echo "=== Summary of $argc_doc_path ==="
    echo

    local total_lines=$(wc -l < "$doc_file")
    echo "Total lines: $total_lines"
    echo

    echo "--- First $preview_lines lines ---"
    head -n "$preview_lines" "$doc_file"
    echo

    if [[ $total_lines -gt $((preview_lines + 10)) ]]; then
      echo "..."
      echo
      echo "--- Last 10 lines ---"
      tail -n 10 "$doc_file"
    fi
  } >>"$LLM_OUTPUT"
}

# @cmd Extract and display only markdown headers from documents
# @option --doc-path! Path to document relative to docs/
# @option --level[1|2|3|4|5|6] Only show headers up to this level
show_headers() {
  local doc_file="$DOCS_DIR/$argc_doc_path"

  if [[ ! -f "$doc_file" ]]; then
    echo "Error: Document not found: $doc_file" >>"$LLM_OUTPUT"
    return 1
  fi

  {
    echo "=== Headers in $argc_doc_path ==="
    echo

    if [[ -n "$argc_level" ]]; then
      # Show headers up to specified level
      local pattern="^#{1,$argc_level} "
      grep -E "$pattern" "$doc_file" || echo "No headers found at levels 1-$argc_level"
    else
      # Show all headers
      grep -E "^#{1,6} " "$doc_file" || echo "No markdown headers found"
    fi
  } >>"$LLM_OUTPUT"
}

# @cmd Search through documentation content
# @option --query! Search term or pattern
# @flag --headers-only Search only in headers
# @flag --case-sensitive Case-sensitive search
search_docs() {
  local grep_opts="-r -n"

  # Add case sensitivity option
  if [[ "$argc_case_sensitive" != "1" ]]; then
    grep_opts="$grep_opts -i"
  fi

  {
    echo "=== Searching for '$argc_query' in $DOCS_DIR ==="
    echo

    if [[ "$argc_headers_only" == "1" ]]; then
      # Search only in markdown headers
      find "$DOCS_DIR" -type f -name "*.md" -exec grep -H -n -E "^#{1,6} .*$argc_query" {} \; 2>/dev/null || \
        echo "No matches found in headers"
    else
      # Full text search
      grep $grep_opts "$argc_query" "$DOCS_DIR" 2>/dev/null || \
        echo "No matches found"
    fi
  } >>"$LLM_OUTPUT"
}

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

      local line_count=$(wc -l < "$doc_file")
      local word_count=$(wc -w < "$doc_file")
      local header_count=$(grep -c -E "^#{1,6} " "$doc_file" 2>/dev/null || echo 0)
      local code_block_count=$(grep -c "^\`\`\`" "$doc_file" 2>/dev/null || echo 0)
      code_block_count=$((code_block_count / 2))  # Divide by 2 for opening/closing pairs

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
          total_lines=$((total_lines + $(wc -l < "$file")))
          total_words=$((total_words + $(wc -w < "$file")))
        done < <(find "$DOCS_DIR" -type f -name "*.md")

        echo "Total lines:      $total_lines"
        echo "Total words:      $total_words"
      fi
    } >>"$LLM_OUTPUT"
  fi
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
