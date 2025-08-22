```bash
#!/bin/bash
# Agent script for blacksmith
# This file is managed by skogcli - manual changes may be overwritten

# @describe Execute the agent command
# @arg message! Message parameter passed to the script

main() {
    local message="$argc_message"
    
    aichat --agent blacksmith --no-stream "$message"
}

eval "$(argc --argc-eval "$0" "$@")"
```

