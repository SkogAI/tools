#!/usr/bin/env bash

# @describe A simple hello world command
# @arg name - The name to greet

main() {
    echo "Hello, $argc_name!"
}

eval "$(argc --argc-eval "$0" "$@")"
