# AGENTS.md - Development Guide for LLM Functions

## Build/Test Commands
- **Build project**: `argc build` (builds tools and agents from tools.txt/agents.txt)
- **Test all**: `argc test` (tests all tools and agents)
- **Test single tool**: `argc test@tool <tool_name>` (e.g., `argc test@tool demo_py.py`)
- **Test single agent**: `argc test@agent <agent_name>` (e.g., `argc test@agent demo`)
- **Run tool**: `argc run@tool <tool_name> '<json_args>'`
- **Run agent**: `argc run@agent <agent_name> <action> '<json_args>'`
- **Check deps**: `argc check` (validates environment variables and dependencies)

## Code Style Guidelines

### Tool Structure
- **Bash**: Use `# @describe`, `# @option`, `# @flag` comments; single `main()` function; end with `eval "$(argc --argc-eval "$0" "$@")"`
- **JavaScript**: Use JSDoc `@typedef {Object} Args` with `@property` definitions; export `run` function
- **Python**: Use type hints with docstrings; define `run()` function with typed parameters

### Naming Conventions
- Tool files: `snake_case.{sh,js,py}` in `tools/` directory
- Agent directories: `lowercase` in `agents/` directory
- Functions: `snake_case` for multi-function agent tools
- Parameters: Use `snake_case` in code, auto-converted to appropriate formats

### Error Handling
- Bash: Use `set -e` at script start; validate required environment variables
- All languages: Handle missing parameters gracefully; provide meaningful error messages
- Use `LLM_OUTPUT` environment variable for output redirection when available