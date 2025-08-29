#!/usr/bin/env bash
set -e

# Simple file processor with XML tagging
# Lists files, wraps content in XML tags, processes sequentially

# Configuration
SOURCE_DIR="${1:-scripts}"
OUTPUT_DIR="converted"
TEMP_DIR="temp"

# Create directories
mkdir -p "$OUTPUT_DIR" "$TEMP_DIR"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

# List all files to process
list_files() {
    find "$SOURCE_DIR" -name "*.sh" -type f | sort
}

# Process a single file
process_file() {
    local input_file="$1"
    local filename=$(basename "$input_file" .sh)
    local output_file="$OUTPUT_DIR/${filename}.sh"
    local temp_input="$TEMP_DIR/current_input.txt"
    local temp_context="$TEMP_DIR/full_context.txt"
    
    log "Processing: $input_file"
    
    # Create XML-wrapped input
    {
        echo "<input>"
        cat "$input_file"
        echo "</input>"
    } > "$temp_input"
    
    # Combine all context (if files exist)
    {
        [ -f "prompt.txt" ] && cat "prompt.txt"
        [ -f "examples.txt" ] && cat "examples.txt" 
        [ -f "rules.txt" ] && cat "rules.txt"
        [ -f "original-script.sh" ] && cat "original-script.sh"
        [ -f "converted-script.sh" ] && cat "converted-script.sh"
        cat "$temp_input"
        [ -f "output.txt" ] && cat "output.txt"
    } > "$temp_context"
    
    # Process with ollama
    if cat "$temp_context" | ollama run qwen2.5-coder:latest > "$output_file"; then
        success "Converted: $input_file -> $output_file"
    else
        error "Failed to convert: $input_file"
        return 1
    fi
}

# Main execution
main() {
    log "Starting file processing..."
    log "Source directory: $SOURCE_DIR"
    log "Output directory: $OUTPUT_DIR"
    
    # Get file list
    files=($(list_files))
    
    if [ ${#files[@]} -eq 0 ]; then
        error "No .sh files found in $SOURCE_DIR"
        exit 1
    fi
    
    log "Found ${#files[@]} files to process:"
    printf '%s\n' "${files[@]}" | sed 's/^/  - /'
    
    echo
    read -p "Continue with processing? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Processing cancelled."
        exit 0
    fi
    
    # Process each file
    local processed=0
    local failed=0
    
    for file in "${files[@]}"; do
        if process_file "$file"; then
            ((processed++))
        else
            ((failed++))
        fi
        echo  # Add spacing between files
    done
    
    # Summary
    echo "=================================="
    success "Processing complete!"
    log "Processed: $processed files"
    [ $failed -gt 0 ] && error "Failed: $failed files"
    log "Output directory: $OUTPUT_DIR"
    
    # Cleanup temp files
    rm -rf "$TEMP_DIR"
}

# Run main function
main "$@"