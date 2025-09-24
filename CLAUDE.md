# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Documentation

@docs/agent.md
@docs/argcfile.md
@docs/tool.md
@docs/environment-variables.md

## Quick Reference

### Core Commands
```bash
argc build          # Build all tools and agents
argc check          # Check environment and dependencies
argc test           # Run tests

argc run@tool <tool_name> '{"param": "value"}'
argc run@agent <agent_name> <action> '{"param": "value"}'
```

### Key Concepts
- **Tools**: Standalone functions in `./tools/` (bash/js/python)
- **Agents**: GPT-like combinations of prompts + tools in `./agents/<name>/`
- **MCP Bridge**: Connect external MCP servers via `./mcp.json`
- **Auto-generation**: Comments in code → JSON schemas in `functions.json`

The documentation above covers the detailed architecture, environment variables, and build system.
