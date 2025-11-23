#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path
# @env SKOGAI=/home/skogix/skogai SkogAI root dir

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DOCS_DIR="${SKOGAI:-/home/skogix/skogai}/docs"

# === Choice Functions ===

# List all docs for argc choice validation
_choice_doc() {
    find "$DOCS_DIR" -type f -name "*.md" -printf "%P\n" 2>/dev/null | sort
}

# List all docs including non-md files
_choice_doc_all() {
    find "$DOCS_DIR" -type f -printf "%P\n" 2>/dev/null | sort
}

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
# @option --document![`_choice_doc_all`] The name or path of the official document to read
read_official_documents() {
  cat -- "$DOCS_DIR/$argc_document" >>"$LLM_OUTPUT"
}

# @cmd Read a document with optional line range
# @option --doc-path[`_choice_doc`] Path to document relative to docs/ (default: README.md)
# @option --start <INT> Starting line number
# @option --end <INT> Ending line number
read_doc() {
  local doc_file="$DOCS_DIR/${argc_doc_path:-README.md}"
  local total_lines
  total_lines=$(wc -l <"$doc_file")

  if [[ -n "$argc_start" && "$argc_start" -gt "$total_lines" ]]; then
    return 1
  fi
  if [[ -n "$argc_end" && "$argc_end" -gt "$total_lines" ]]; then
    return 1
  fi

  if [[ -n "$argc_start" && -n "$argc_end" ]]; then
    sed -n "${argc_start},${argc_end}p" "$doc_file" >>"$LLM_OUTPUT"
  elif [[ -n "$argc_start" ]]; then
    tail -n "+${argc_start}" "$doc_file" >>"$LLM_OUTPUT"
  elif [[ -n "$argc_end" ]]; then
    head -n "$argc_end" "$doc_file" >>"$LLM_OUTPUT"
  else
    cat -- "$doc_file" >>"$LLM_OUTPUT"
  fi
}

# @cmd Show recently modified documents
# @option --count <INT> Number of files to show (default: 10)
# @option --days <INT> Only files modified within N days
recent_docs() {
  local count="${argc_count:-10}"

  if [[ -n "$argc_days" ]]; then
    find "$DOCS_DIR" -type f -name "*.md" -mtime -"$argc_days" -printf "%T@\t%P\n" 2>/dev/null | sort -rn | head -n "$count" | cut -f2 >>"$LLM_OUTPUT"
  else
    find "$DOCS_DIR" -type f -name "*.md" -printf "%T@\t%P\n" 2>/dev/null | sort -rn | head -n "$count" | cut -f2 >>"$LLM_OUTPUT"
  fi
}

# @cmd Compare two documents side by side
# @option --doc1![`_choice_doc`] First document path (relative to docs/)
# @option --doc2![`_choice_doc`] Second document path (relative to docs/)
# @flag --unified Show unified diff format
compare_docs() {
  local file1="$DOCS_DIR/$argc_doc1"
  local file2="$DOCS_DIR/$argc_doc2"

  if [[ "$argc_unified" == "1" ]]; then
    diff -u -- "$file1" "$file2" >>"$LLM_OUTPUT" || true
  else
    diff -- "$file1" "$file2" >>"$LLM_OUTPUT" || true
  fi
}

# @cmd Extract code blocks from a markdown document
# @option --doc-path![`_choice_doc`] Path to document relative to docs/
# @option --lang Filter by language (e.g., "bash", "python", "js")
extract_code_blocks() {
  local doc_file="$DOCS_DIR/$argc_doc_path"

  if [[ -n "$argc_lang" ]]; then
    awk -v lang="$argc_lang" '
      /^```'"$argc_lang"'/ { capture=1; next }
      /^```/ && capture { capture=0; print "---"; next }
      capture { print }
    ' "$doc_file" >>"$LLM_OUTPUT"
  else
    awk '
      /^```[a-zA-Z]/ { lang=$0; gsub(/```/, "", lang); print "=== " lang " ==="; capture=1; next }
      /^```/ && capture { capture=0; print ""; next }
      capture { print }
    ' "$doc_file" >>"$LLM_OUTPUT"
  fi
}

# @cmd Show documentation tree structure
# @option --depth <INT> Maximum depth to display (default: 3)
doc_tree() {
  local depth="${argc_depth:-3}"

  if command -v tree &>/dev/null; then
    tree -L "$depth" --noreport "$DOCS_DIR" >>"$LLM_OUTPUT"
  else
    find "$DOCS_DIR" -maxdepth "$depth" -printf "%P\n" | sort >>"$LLM_OUTPUT"
  fi
}

# @cmd Concatenate multiple documents into one output
# @option --docs+[`_choice_doc`] List of document paths (relative to docs/)
# @flag --with-headers Include filename headers between documents
concat_docs() {
  for doc in "${argc_docs[@]}"; do
    local doc_file="$DOCS_DIR/$doc"

    if [[ "$argc_with_headers" == "1" ]]; then
      echo "# ===== $doc =====" >>"$LLM_OUTPUT"
      echo >>"$LLM_OUTPUT"
    fi

    cat -- "$doc_file" >>"$LLM_OUTPUT"
    echo >>"$LLM_OUTPUT"
  done
}

# @cmd Find TODOs and FIXMEs in documentation
# @option --pattern Custom pattern to search for (default: TODO|FIXME|XXX|HACK)
find_todos() {
  local pattern="${argc_pattern:-TODO|FIXME|XXX|HACK}"
  grep -r -n -E "$pattern" "$DOCS_DIR" --include="*.md" 2>/dev/null >>"$LLM_OUTPUT"
}

# @cmd Count words in documents (useful for content planning)
# @option --sort-by[name|words|lines] Sort results by (default: words)
word_counts() {
  local sort_by="${argc_sort_by:-words}"

  {
    while IFS= read -r file; do
      local relpath="${file#$DOCS_DIR/}"
      local words lines
      words=$(wc -w <"$file")
      lines=$(wc -l <"$file")
      printf "%s\t%d\t%d\n" "$relpath" "$words" "$lines"
    done < <(find "$DOCS_DIR" -type f -name "*.md" | sort)
  } | case "$sort_by" in
    words) sort -t$'\t' -k2 -n -r ;;
    lines) sort -t$'\t' -k3 -n -r ;;
    *) cat ;;
  esac >>"$LLM_OUTPUT"
}

# @cmd List all documentation files with optional filtering
# @option --pattern File pattern to match (e.g., "*.md", "argc*")
# @option --type[files|dirs|all] What to list (default: files)
# @flag --recursive Include subdirectories
list_docs() {
  local type="${argc_type:-files}"
  local pattern="${argc_pattern:-*}"
  local depth_opt=""

  [[ "$argc_recursive" != "1" ]] && depth_opt="-maxdepth 1"

  case "$type" in
    files) find "$DOCS_DIR" $depth_opt -type f -name "$pattern" -printf "%P\n" | sort >>"$LLM_OUTPUT" ;;
    dirs)  find "$DOCS_DIR" $depth_opt -type d -name "$pattern" -printf "%P\n" | sort >>"$LLM_OUTPUT" ;;
    all)   find "$DOCS_DIR" $depth_opt -name "$pattern" -printf "%P\n" | sort >>"$LLM_OUTPUT" ;;
  esac
}

# @cmd Show summary of a document (first N lines + last 10 lines)
# @option --doc-path![`_choice_doc`] Path to document relative to docs/
# @option --lines <INT> Number of preview lines from start (default: 20)
summarize_doc() {
  local doc_file="$DOCS_DIR/$argc_doc_path"
  local preview_lines="${argc_lines:-20}"
  local total_lines
  total_lines=$(wc -l <"$doc_file")

  {
    head -n "$preview_lines" -- "$doc_file"

    if [[ $total_lines -gt $((preview_lines + 10)) ]]; then
      echo "..."
      tail -n 10 -- "$doc_file"
    fi
  } >>"$LLM_OUTPUT"
}

# @cmd Extract and display only markdown headers from documents
# @option --doc-path![`_choice_doc`] Path to document relative to docs/
# @option --level[1|2|3|4|5|6] Only show headers up to this level
show_headers() {
  local doc_file="$DOCS_DIR/$argc_doc_path"

  if [[ -n "$argc_level" ]]; then
    local pattern="^#{1,$argc_level} "
    grep -E "$pattern" -- "$doc_file" >>"$LLM_OUTPUT"
  else
    grep -E "^#{1,6} " -- "$doc_file" >>"$LLM_OUTPUT"
  fi
}

# @cmd Search through documentation content
# @option --query! Search term or pattern
# @flag --headers-only Search only in headers
# @flag --case-sensitive Case-sensitive search
# @option --context <INT> Lines of context around matches
search_docs() {
  local grep_opts=(-r -n --include="*.md")

  if [[ "$argc_case_sensitive" != "1" ]]; then
    grep_opts+=(-i)
  fi

  if [[ -n "$argc_context" ]]; then
    grep_opts+=(-C "$argc_context")
  fi

  if [[ "$argc_headers_only" == "1" ]]; then
    find "$DOCS_DIR" -type f -name "*.md" -exec grep -H -n -E "^#{1,6} .*$argc_query" {} \; 2>/dev/null >>"$LLM_OUTPUT"
  else
    grep "${grep_opts[@]}" -- "$argc_query" "$DOCS_DIR" 2>/dev/null >>"$LLM_OUTPUT"
  fi
}

# @cmd Show statistics about documentation
# @option --doc-path[`_choice_doc`] Path to document relative to docs/ (optional, shows all if omitted)
doc_stats() {
  if [[ -n "$argc_doc_path" ]]; then
    local doc_file="$DOCS_DIR/$argc_doc_path"
    local line_count word_count header_count code_block_count
    line_count=$(wc -l <"$doc_file")
    word_count=$(wc -w <"$doc_file")
    header_count=$(grep -c -E "^#{1,6} " -- "$doc_file" 2>/dev/null || echo 0)
    code_block_count=$(grep -c "^\`\`\`" -- "$doc_file" 2>/dev/null || echo 0)
    code_block_count=$((code_block_count / 2))

    {
      printf "lines: %d\nwords: %d\nheaders: %d\ncode_blocks: %d\n" \
        "$line_count" "$word_count" "$header_count" "$code_block_count"
    } >>"$LLM_OUTPUT"
  else
    local total_files md_files total_dirs total_lines=0 total_words=0
    total_files=$(find "$DOCS_DIR" -type f | wc -l)
    md_files=$(find "$DOCS_DIR" -type f -name "*.md" | wc -l)
    total_dirs=$(find "$DOCS_DIR" -type d | wc -l)

    while IFS= read -r file; do
      total_lines=$((total_lines + $(wc -l <"$file")))
      total_words=$((total_words + $(wc -w <"$file")))
    done < <(find "$DOCS_DIR" -type f -name "*.md")

    {
      printf "files: %d\nmd_files: %d\ndirs: %d\nlines: %d\nwords: %d\n" \
        "$total_files" "$md_files" "$total_dirs" "$total_lines" "$total_words"
    } >>"$LLM_OUTPUT"
  fi
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"
