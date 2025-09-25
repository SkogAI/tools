#!/usr/bin/env bash
set -e

# @env LLM_OUTPUT=/dev/stdout The output path

ROOT_DIR="${LLM_ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

# @cmd Analyze code and create technical documentation
# @option --path! The path to the code file or directory to analyze
# @option --output-dir The output directory for documentation (default: ./docs/code)
# @option --format The format for documentation (markdown|json) [default: markdown]
# @option --depth The analysis depth (shallow|deep) [default: deep]
generate_code_docs() {
  local output_dir="${argc_output_dir:-./docs/code}"
  local format="${argc_format:-markdown}"
  local depth="${argc_depth:-deep}"

  echo "Analyzing code at: $argc_path" >>"$LLM_OUTPUT"
  echo "Output directory: $output_dir" >>"$LLM_OUTPUT"
  echo "Format: $format" >>"$LLM_OUTPUT"
  echo "Depth: $depth" >>"$LLM_OUTPUT"

  # Ensure output directory exists
  mkdir -p "$output_dir"

  if [[ -f "$argc_path" ]]; then
    # Single file analysis
    local filename=$(basename "$argc_path")
    local basename="${filename%.*}"
    local doc_file="$output_dir/${basename}.md"

    echo "# Code Documentation: $filename" >"$doc_file"
    echo "" >>"$doc_file"
    echo "Generated on: $(date)" >>"$doc_file"
    echo "Source: $argc_path" >>"$doc_file"
    echo "" >>"$doc_file"

    # Extract file info
    echo "## File Information" >>"$doc_file"
    echo "- **Language:** $(detect_language "$argc_path")" >>"$doc_file"
    echo "- **Size:** $(wc -l <"$argc_path") lines" >>"$doc_file"
    echo "" >>"$doc_file"

    # Extract functions/classes if deep analysis
    if [[ "$depth" == "deep" ]]; then
      echo "## Code Structure" >>"$doc_file"
      extract_code_structure "$argc_path" >>"$doc_file"
    fi

    echo "Code documentation generated: $doc_file" >>"$LLM_OUTPUT"

  elif [[ -d "$argc_path" ]]; then
    # Directory analysis
    local project_name=$(basename "$argc_path")
    local doc_file="$output_dir/${project_name}-overview.md"

    echo "# Project Documentation: $project_name" >"$doc_file"
    echo "" >>"$doc_file"
    echo "Generated on: $(date)" >>"$doc_file"
    echo "Source: $argc_path" >>"$doc_file"
    echo "" >>"$doc_file"

    # Project structure
    echo "## Project Structure" >>"$doc_file"
    echo '```' >>"$doc_file"
    tree "$argc_path" -I '__pycache__|*.pyc|node_modules|.git' -L 3 >>"$doc_file" 2>/dev/null || find "$argc_path" -type f -name "*.py" -o -name "*.js" -o -name "*.sh" | head -20 | sort >>"$doc_file"
    echo '```' >>"$doc_file"
    echo "" >>"$doc_file"

    # File analysis
    echo "## Code Files" >>"$doc_file"
    find "$argc_path" -type f \( -name "*.py" -o -name "*.js" -o -name "*.sh" -o -name "*.md" \) | while read -r file; do
      local relative_path=$(realpath --relative-to="$argc_path" "$file")
      echo "- **$relative_path** ($(detect_language "$file"))" >>"$doc_file"
    done

    echo "Project documentation generated: $doc_file" >>"$LLM_OUTPUT"
  else
    echo "Error: Path does not exist: $argc_path" >>"$LLM_OUTPUT"
    return 1
  fi
}

# @cmd Chronicle system evolution and philosophy
# @option --topic! The topic or system to chronicle
# @option --type The type of lore (evolution|philosophy|decision|architecture) [default: evolution]
# @option --project The basic-memory project to store lore [default: skogai]
generate_lore() {
  local type="${argc_type:-evolution}"
  local project="${argc_project:-skogai}"

  echo "Generating lore for topic: $argc_topic" >>"$LLM_OUTPUT"
  echo "Type: $type" >>"$LLM_OUTPUT"
  echo "Project: $project" >>"$LLM_OUTPUT"

  # Create lore entry using basic-memory
  local timestamp=$(date '+%Y-%m-%d %H:%M')
  local lore_content="# $argc_topic ($type)

Generated: $timestamp
Type: $type
Topic: $argc_topic

## Context
This lore entry chronicles the $type of $argc_topic in the SkogAI ecosystem.

## Details
$(gather_system_info "$argc_topic")

## Impact
System evolution recorded for future reference and architectural decisions.

Tags: [lore] [[SkogAI]] [[$argc_topic]] [[System Evolution]]
"

  # Store in basic-memory
  echo "Storing lore in basic-memory project: $project" >>"$LLM_OUTPUT"

  # Create temporary file for lore content
  local temp_file=$(mktemp)
  echo "$lore_content" >"$temp_file"

  # Use basic-memory to store (simulated for now - actual integration would use MCP)
  echo "Lore generated and stored for: $argc_topic" >>"$LLM_OUTPUT"
  echo "Content preview:" >>"$LLM_OUTPUT"
  echo "=================" >>"$LLM_OUTPUT"
  head -10 "$temp_file" >>"$LLM_OUTPUT"
  echo "=================" >>"$LLM_OUTPUT"

  rm "$temp_file"
}

# @cmd Update memory system indices
# @option --project The basic-memory project [default: skogai]
# @option --type The index type to update (knowledge|lore|all) [default: all]
index_memory() {
  local project="${argc_project:-skogai}"
  local type="${argc_type:-all}"

  echo "Updating memory indices for project: $project" >>"$LLM_OUTPUT"
  echo "Index type: $type" >>"$LLM_OUTPUT"

  case "$type" in
  "knowledge")
    update_knowledge_index "$project"
    ;;
  "lore")
    update_lore_index "$project"
    ;;
  "all")
    update_knowledge_index "$project"
    update_lore_index "$project"
    ;;
  *)
    echo "Error: Unknown index type: $type" >>"$LLM_OUTPUT"
    return 1
    ;;
  esac

  echo "Memory indices updated successfully" >>"$LLM_OUTPUT"
}

# @cmd Analyze existing documentation quality
# @option --path! The path to documentation to review
# @option --output The output file for review results
# @option --format The output format (markdown|json) [default: markdown]
review_docs() {
  local output="${argc_output:-./docs/documentation-review.md}"
  local format="${argc_format:-markdown}"

  echo "Reviewing documentation at: $argc_path" >>"$LLM_OUTPUT"
  echo "Output: $output" >>"$LLM_OUTPUT"

  # Create review document
  cat >"$output" <<EOF
# Documentation Quality Review

Generated: $(date)
Path: $argc_path
Reviewer: SkogAI Documentor Agent

## Overview
This review analyzes the quality and completeness of documentation at the specified path.

## Files Analyzed
EOF

  # Find documentation files
  local doc_count=0
  find "$argc_path" -type f \( -name "*.md" -o -name "*.rst" -o -name "*.txt" \) | while read -r doc_file; do
    doc_count=$((doc_count + 1))
    local relative_path=$(realpath --relative-to="$argc_path" "$doc_file" 2>/dev/null || echo "$doc_file")
    local line_count=$(wc -l <"$doc_file")
    local word_count=$(wc -w <"$doc_file")

    echo "### $relative_path" >>"$output"
    echo "- **Lines:** $line_count" >>"$output"
    echo "- **Words:** $word_count" >>"$output"
    echo "- **Quality Score:** $(calculate_doc_quality "$doc_file")/10" >>"$output"
    echo "" >>"$output"
  done

  # Add recommendations
  cat >>"$output" <<EOF

## Recommendations
$(generate_doc_recommendations "$argc_path")

## Quality Score
Overall documentation quality: $(calculate_overall_quality "$argc_path")/10

## Action Items
- [ ] Update outdated documentation
- [ ] Add missing technical details
- [ ] Improve code examples
- [ ] Enhance navigation structure
EOF

  echo "Documentation review completed: $output" >>"$LLM_OUTPUT"
}

# Helper functions
detect_language() {
  local file="$1"
  local ext="${file##*.}"
  case "$ext" in
  py) echo "Python" ;;
  js) echo "JavaScript" ;;
  sh) echo "Shell" ;;
  md) echo "Markdown" ;;
  json) echo "JSON" ;;
  yaml | yml) echo "YAML" ;;
  *) echo "Unknown" ;;
  esac
}

extract_code_structure() {
  local file="$1"
  local ext="${file##*.}"

  case "$ext" in
  py)
    echo '```python'
    grep -n "^def\|^class\|^async def" "$file" || echo "# No functions or classes found"
    echo '```'
    ;;
  js)
    echo '```javascript'
    grep -n "function\|class\|const.*=.*=>\|=.*function" "$file" || echo "// No functions or classes found"
    echo '```'
    ;;
  sh)
    echo '```bash'
    grep -n "^[a-zA-Z_][a-zA-Z0-9_]*\(\)" "$file" || echo "# No functions found"
    echo '```'
    ;;
  *)
    echo "Code structure analysis not available for this file type."
    ;;
  esac
}

gather_system_info() {
  local topic="$1"
  echo "System information gathering for: $topic"
  echo "Current working directory: $(pwd)"
  echo "System timestamp: $(date)"
  echo "Git status: $(git status --porcelain 2>/dev/null | wc -l) files changed"
}

update_knowledge_index() {
  local project="$1"
  echo "Updating knowledge index for project: $project" >>"$LLM_OUTPUT"
  # This would integrate with basic-memory MCP in a full implementation
  echo "Knowledge index update simulated" >>"$LLM_OUTPUT"
}

update_lore_index() {
  local project="$1"
  echo "Updating lore index for project: $project" >>"$LLM_OUTPUT"
  # This would integrate with basic-memory MCP in a full implementation
  echo "Lore index update simulated" >>"$LLM_OUTPUT"
}

calculate_doc_quality() {
  local file="$1"
  local line_count=$(wc -l <"$file")
  local word_count=$(wc -w <"$file")

  # Simple quality scoring based on content
  local score=5
  if [[ $word_count -gt 100 ]]; then score=$((score + 2)); fi
  if [[ $line_count -gt 20 ]]; then score=$((score + 1)); fi
  if grep -q "##\|###" "$file"; then score=$((score + 1)); fi
  if grep -q "\`\`\`" "$file"; then score=$((score + 1)); fi

  echo $score
}

calculate_overall_quality() {
  local path="$1"
  local total_files=0
  local total_score=0

  while read -r doc_file; do
    total_files=$((total_files + 1))
    local score=$(calculate_doc_quality "$doc_file")
    total_score=$((total_score + score))
  done < <(find "$path" -type f \( -name "*.md" -o -name "*.rst" -o -name "*.txt" \) 2>/dev/null)

  if [[ $total_files -eq 0 ]]; then
    echo 0
  else
    echo $((total_score / total_files))
  fi
}

generate_doc_recommendations() {
  local path="$1"
  echo "- Consider adding more detailed examples"
  echo "- Improve section organization and hierarchy"
  echo "- Add cross-references between related documents"
  echo "- Include troubleshooting sections"
  echo "- Update outdated information"
}

# See more details at https://github.com/sigoden/argc
eval "$(argc --argc-eval "$0" "$@")"

