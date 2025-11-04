#!/usr/bin/env bash
set -e

# @describe Manages Git working directory status and context
# @env SKOGAI_DOT_FOLDER Path to dotfiles folder, required for script execution

main() {
  # Ensure SKOGAI_DOT_FOLDER is set
  if [ -z "$SKOGAI_DOT_FOLDER" ]; then
    echo "Error: SKOGAI_DOT_FOLDER environment variable is not set."
    exit 1
  fi

  # Start context for Git operations
  "$SKOGAI_DOT_FOLDER"/scripts/context-start.sh "git"

  # Working directory status
  printf "## Working Directory Status\n"
  if git status --porcelain 2>/dev/null | grep -q .; then
    git status --short
    echo
    printf "## Diff Summary\n"
    git diff --stat 2>/dev/null || echo "No unstaged changes"

    if git diff --cached --quiet 2>/dev/null; then
      echo "No staged changes"
    else
      echo
      printf "## Staged Changes\n"
      git diff --cached --stat
    fi
  else
    echo "Working directory clean"
  fi

  # End context for Git operations
  "$SKOGAI_DOT_FOLDER"/scripts/context-end.sh "git"
}

eval "$(argc --argc-eval "$0" "$@")"
