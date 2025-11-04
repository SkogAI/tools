```bash
#!/bin/bash

# @describe Processes lines from an input file and outputs results to a file
# @arg input_file! Path to the input file containing test cases
# @arg output_file! Path to the output file where results will be saved
# @env DEBUG Set to enable debug output

main() {
    local input_file="$argc_input_file"
    local output_file="$argc_output_file"

    local total_lines=$(wc -l <"$input_file")
    local current_line=0

    while IFS= read -r line || [ -n "$line" ]; do
        ((current_line++))
        echo "Processing line $current_line of $total_lines: $line"
        output=$(echo "$line" | skogparse --execute)
        echo "Output: $output"
        echo "$output" >>"$output_file"
    done <"$input_file"

    if [ -n "$DEBUG" ]; then
        echo "Processed all lines. Total lines: $total_lines"
    fi
}

eval "$(argc --argc-eval "$0" "$@")"
```

