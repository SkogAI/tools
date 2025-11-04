```bash
#!/usr/bin/env bash
set -e

# @describe Creates feature branch and .llm directory structure
# @arg name! Name of the feature to start
# @env DEBUG Set to enable debug output

main() {
    local name="$argc_name"
    
    # Start git-flow feature
    "$(dirname "$0")/git/feature-start.sh" "$name"
    
    # Create .llm documentation structure
    "$(dirname "$0")/llm/feature-start.sh" "$name"
    
    echo "Feature workflow complete for $name"
}

eval "$(argc --argc-eval "$0" "$@")"
```

