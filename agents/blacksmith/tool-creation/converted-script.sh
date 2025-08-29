<expected-output>
<example-output>
#!/usr/bin/env bash
set -e

# @describe Creates a personalized greeting
# @arg name! Name to greet
# @arg greeting=Hello Optional greeting word
# @env CUSTOM_SUFFIX Optional suffix to add to greeting
# @env DEBUG Set to enable debug output

main() {
    local name="$argc_name"
    local greeting="$argc_greeting"
    
    if [ -n "$CUSTOM_SUFFIX" ]; then
        echo "$greeting, $name $CUSTOM_SUFFIX!"
    else
        echo "$greeting, $name!"
    fi
    
    # Show some info
    echo "Script called with $argc___argc arguments"
    if [ -n "$DEBUG" ]; then
        echo "DEBUG: name='$name', greeting='$greeting'"
    fi
}

eval "$(argc --argc-eval "$0" "$@")"
</example-output>
</expected-output>
