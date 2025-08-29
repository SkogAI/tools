```bash
#!/usr/bin/env bash
set -e

# @describe Starts a workspace context and runs tree with gitignore
# @arg workspace! Name of the workspace to start

main() {
    local workspace="$argc_workspace"
    
    $SKOGAI_DOT_FOLDER/scripts/context-start.sh "$workspace"
    tree . --gitignore
    $SKOGAI_DOT_FOLDER/scripts/context-end.sh "$workspace"
}

eval "$(argc --argc-eval "$0" "$@")"
```

