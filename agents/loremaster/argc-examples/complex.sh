#!/usr/bin/env bash

# @describe A more complex example with flags and options
# @flag -f --force - Force the action
# @option -o --output - The output file
# @arg file - The input file

main() {
    if [ -n "$argc_force" ]; then
        echo "Forcing the action"
    fi

    if [ -n "$argc_output" ]; then
        echo "Writing output to $argc_output"
    else
        echo "Writing output to stdout"
    fi

    echo "Processing file $argc_file"
}

eval "$(argc --argc-eval "$0" "$@")"
