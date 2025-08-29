# Librarian Agent Guidelines

## Build/Test Commands
- Run tool: `./tools.sh <command> [options]`
- Test single function: `bash -c "source tools.sh && <function_name>"`
- Validate argc syntax: `argc --argc-check tools.sh`

## Code Style Guidelines
- **Shell**: Use bash with `set -e` for error handling
- **Functions**: Follow argc comment syntax (`# @cmd`, `# @option`)
- **Variables**: Use `$argc_<name>` for argc parameters, uppercase for constants
- **Paths**: Always use absolute paths or `$ROOT_DIR` relative paths
- **Output**: Direct all output to `$LLM_OUTPUT` (defaults to stdout)
- **Guards**: Use `guard_path.sh` for destructive file operations
- **Error Handling**: Let commands fail naturally with `set -e`
- **Quotes**: Always quote variables to handle spaces: `"$var"`

## Project Structure
- `tools.sh`: Main executable with argc-based commands
- `functions.json`: Function definitions for agent integration
- `archives/`, `official/`: Symlinks to documentation directories