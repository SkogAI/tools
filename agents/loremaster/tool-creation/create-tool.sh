#!/usr/bin/env bash
# Convert all scripts with proper file processing

# Create converted directory if it doesn't exist
mkdir -p converted

# Process each script file
for script in scripts/*.sh; do
  # Get basename without extension, then add single .sh
  script_name=$(basename "$script" .sh)
  output_file="converted/${script_name}.sh"
  
  echo "Processing: $script -> $output_file"
  
  # Create input with XML tags
  {
    echo "<input>"
    cat "$script"
    echo "</input>"
  } > input.txt
  
  # Combine all context files
  cat prompt.txt examples.txt rules.txt original-script.sh converted-script.sh input.txt output.txt > run.txt
  
  # Run conversion and save to proper filename
  cat run.txt | ollama run qwen2.5-coder:latest > "$output_file"
  
  echo "Converted: $script -> $output_file"
done

echo "All scripts converted successfully!"
