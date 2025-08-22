<original-input>
<example-input>
#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <name> [greeting]"
    echo "Creates a personalized greeting"
    exit 1
fi

name="$1"
greeting="${2:-Hello}"

if [ -n "$CUSTOM_SUFFIX" ]; then
    echo "$greeting, $name $CUSTOM_SUFFIX!"
else
    echo "$greeting, $name!"
fi

echo "Script called with $# arguments"
if [ -n "$DEBUG" ]; then
    echo "DEBUG: name='$name', greeting='$greeting'"
fi
</example-input>
</original-input>
