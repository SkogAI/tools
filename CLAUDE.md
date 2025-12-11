# CLAUDE.md

## Rules (MUST READ FIRST)

@docs/rules.md

## Documentation

@docs/agent.md
@docs/argcfile.md
@docs/tool-development-guide.md
@docs/environment-variables.md
@docs/command-runner.md
@docs/variables.md
@docs/bash-best-practices.md

## Quick Reference

### Core Commands

```bash
# Build
argc build                          # Build all tools and agents
argc build@tool <name>...           # Build specific tools
argc build@agent <name>...          # Build specific agents
argc check                          # Check environment and dependencies

# Run
argc run@tool <name> '{"param": "value"}'
argc run@agent <name> <action> '{"param": "value"}'

# Test
argc test                           # Test all
argc test@tool                      # Test specific tools
argc test@agent                     # Test specific agents

# MCP
argc mcp start                      # Start/restart MCP bridge server
argc mcp stop                       # Stop MCP bridge server
argc mcp run@tool <name> '{"json"}' # Run MCP tool
argc mcp logs                       # Show MCP logs

# Clean
argc clean                          # Clean all generated files
argc clean@tool                     # Clean tools only
argc clean@agent                    # Clean agents only

# Create
argc create@tool <name>.sh param1 param2!  # Create new tool
# Parameter suffixes: ! = required, * = array (optional), + = array (required)
```

### Key Concepts

- **Tools**: Standalone functions in `./tools/` (bash/js/python) with argc comment-driven schemas
- **Agents**: GPT-like combinations of prompts + tools in `./agents/<name>/`
  - Pattern: **Agent = Instructions + Tools + Documents**
  - See @docs/agent.md for complete structure
- **MCP Bridge**: Connect external MCP servers via `./mcp.json`
  - Three-layer architecture: MCP Server → MCP Bridge → External MCP ecosystem
- **Auto-generation**: Comments in code → JSON schemas in `functions.json`
  - argc parses `@describe`, `@option`, `@flag` tags
  - Build pipeline creates schemas and wrapper scripts
- **Runtime Environment**: Tools execute with `LLM_*` environment variables
  - `LLM_OUTPUT` - Output destination (CRITICAL: write here, not stdout)
  - `LLM_ROOT_DIR`, `LLM_TOOL_NAME`, `LLM_TOOL_CACHE_DIR`
  - See @docs/environment-variables.md for complete list

### Tool Development Rules

**CRITICAL**: All tools MUST write output to `$LLM_OUTPUT`, never stdout directly.

```bash
# Correct
echo "result" >> "$LLM_OUTPUT"

# Incorrect
echo "result"  # Wrong - goes to stdout
```

See @docs/rules.md for complete rules and @docs/bash-best-practices.md for patterns.

## Architecture Overview

The documentation above covers the detailed architecture, environment variables, and build system.

**Key architecture patterns:**
- **argc-based Tool System**: Comment-driven code generation with declarative schemas
- **Agent Architecture**: `index.yaml` defines instructions, variables, documents; `tools.sh` implements functions
- **MCP Integration**: Exposes tools via Model Context Protocol for universal access
- **Build Pipeline**: argc → `build-declarations.sh` → `functions.json` → wrapper scripts

See @docs/tool-development-guide.md, @docs/agent.md, and @docs/argcfile.md for complete architectural details.
