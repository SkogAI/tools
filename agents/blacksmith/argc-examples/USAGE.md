# Argc Usage Guide for Bash Scripts

This guide explains how to use `argc` to create your own bash scripts with command-line argument parsing.

## Basic Structure

A typical `argc` script has the following structure:

```bash
#!/usr/bin/env bash

# @describe Your script's description
# @arg ...
# @option ...
# @flag ...

main() {
    # Your script's logic here
}

eval "$(argc --argc-eval "$0" "$@")"
```

*   The `#!` line is the shebang, which tells the system to execute the script with bash.
*   The `@describe` tag provides a description of your script, which is shown in the help message.
*   The `@arg`, `@option`, and `@flag` tags define the arguments, options, and flags that your script accepts.
*   The `main()` function contains the main logic of your script.
*   The `eval` line is the `argc` magic that parses the arguments and makes them available to your script as variables.

## Arguments, Options, and Flags

*   **Arguments** are positional parameters that are required by your script. They are defined using the `@arg` tag.
*   **Options** are named parameters that can be used to modify the behavior of your script. They are defined using the `@option` tag.
*   **Flags** are a special type of option that don't take a value. They are used to enable or disable a feature. They are defined using the `@flag` tag.

## Accessing Arguments

`argc` makes the arguments, options, and flags available to your script as variables with the `argc_` prefix. For example, if you have an argument named `file`, you can access its value in your script as `$argc_file`.

## Example

Here's an example of a script that takes a filename as an argument and an optional output file as an option:

```bash
#!/usr/bin/env bash

# @describe A simple script to demonstrate argc
# @option -o --output - The output file
# @arg file - The input file

main() {
    if [ -n "$argc_output" ]; then
        echo "Writing output to $argc_output"
    else
        echo "Writing output to stdout"
    fi

    echo "Processing file $argc_file"
}

eval "$(argc --argc-eval "$0" "$@")"
```

To run this script, you would use the following command:

```bash
./your-script.sh --output output.txt input.txt
```

This would set the `argc_output` variable to `output.txt` and the `argc_file` variable to `input.txt`.
