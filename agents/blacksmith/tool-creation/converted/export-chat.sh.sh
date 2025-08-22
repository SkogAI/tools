```bash
#!/usr/bin/env bash

# @describe Synchronizes the project and runs a script
# @arg SKOGAI_DOT_FOLDER! Path to the skogai dot folder
# @flag --silent Run in silent mode
# @env SKOGAI_DOT_FOLDER Path to the skogai dot folder (environment variable)

main() {
    local SKOGAI_DOT_FOLDER="$argc_SKOGAI_DOT_FOLDER"
    
    # Copy project files
    cp -r /home/skogix/.claude/projects/-home-skogix--skogai/* /home/skogix/.claude/projects/-home-skogix-skogai/
    
    # Run the script with silent mode if specified
    if [ "$argc__silent" ]; then
        $SKOGAI_DOT_FOLDER/scripts/specstory sync --silent
    else
        $SKOGAI_DOT_FOLDER/scripts/specstory sync
    fi
}

eval "$(argc --argc-eval "$0" "$@")"
```

