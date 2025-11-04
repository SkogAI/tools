#!/usr/bin/env bash

# @describe Simple script to print a greeting
# @arg name! Name of the person to greet
# @env DEBUG Optional environment variable to enable debug output

main() {
  local name="$argc_name"

  echo "Hello, $name!"

  # Show some info if DEBUG is set
  if [ -n "$DEBUG" ]; then
    echo "DEBUG: name='$name'"
  fi
}

eval "$(argc --argc-eval "$0" "$@")"
