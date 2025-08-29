```bash
#!/usr/bin/env bash
set -e

# @describe Creates hotfix branch for emergency fixes
# @arg name! Name of the hotfix branch
# @env DEBUG Set to enable debug output

main() {
    local name="$argc_name"
    
    # start git-flow hotfix
    "$(dirname "$0")/git/hotfix-start.sh" "$name"

    if [ -n "$DEBUG" ]; then
        echo "Hotfix workflow started for $name"
    fi
}

eval "$(argc --argc-eval "$0" "$@")"
```

