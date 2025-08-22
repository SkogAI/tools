```bash
#!/usr/bin/env bash
set -e

# @describe Display current and spec tasks from various files
# @env SKOGAI_DOT_FOLDER Dot folder containing scripts and files

main() {
    local skogai_dot_folder="$SKOGAI_DOT_FOLDER"
    
    "$skogai_dot_folder"/scripts/context-start.sh "todo"

    # Check for todo files in common locations
    if [[ -f "$skogai_dot_folder/todo.md" ]]; then
        echo "## Current Tasks (todo.md)"
        cat "$skogai_dot_folder/todo.md" | head -20
    elif [[ -f "$skogai_dot_folder/.docs/todo.md" ]]; then
        echo "## Current Tasks (.docs/todo.md)"
        cat "$skogai_dot_folder/.docs/todo.md" | head -20
    elif [[ -f "$skogai_dot_folder/TODO.md" ]]; then
        echo "## Current Tasks (TODO.md)"
        cat "$skogai_dot_folder/TODO.md" | head -20
    else
        echo "## Current Tasks"
        echo "No todo file found"
    fi

    # Check for spec tasks
    if [[ -d "$skogai_dot_folder/spec" ]]; then
        echo
        echo "## Spec Tasks"
        find "$skogai_dot_folder/spec" -name "tasks.md" -exec echo "### {}" \; -exec head -10 {} \; 2>/dev/null || echo "No spec tasks found"
    fi

    "$skogai_dot_folder"/scripts/context-end.sh "todo"
}

eval "$(argc --argc-eval "$0" "$@")"
```

