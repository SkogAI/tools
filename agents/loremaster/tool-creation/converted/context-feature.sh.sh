#!/usr/bin/env bash
set -e
"$SKOGAI_DOT_FOLDER"/scripts/context-start.sh "feature"

# current branch and status
printf "## Git Features\n"
git-flow feature

# reminder about tmp branch usage
current_branch=$(git branch --show-current)
if [[ "$current_branch" == "feature/tmp" ]]; then
  printf "\n⚠️  Currently in tmp feature branch - create proper feature branch when task is known\n"
fi

printf "## Feature Diff \n"
git-flow feature diff

"$SKOGAI_DOT_FOLDER"/scripts/context-end.sh "feature"
