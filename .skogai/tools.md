# Tools Directory Quick Reference

## Core Commands
- `argc` - Show all available commands
- `argc build` - Build all tools, agents, and MCP functions
- `argc mcp start` - Start MCP Bridge server
- `argc run@tool <tool> <json>` - Execute tool with JSON input
- `argc run@agent <agent> <action> <json>` - Execute agent action
- `argc list@tool` - List available tools
- `argc list@agent` - List available agents
- `argc check` - Verify dependencies and environment

## Key Files
- `Argcfile.sh` - Main argc CLI definition (23KB)
- `tools.txt` - Tools to build (if exists)
- `agents.txt` - Agents to build (if exists) 
- `mcp.json` - MCP server configuration (if exists)
- `functions.json` - Generated function declarations

## Directory Structure
- `bin/` - Built executable tools and agents
- `agents/` - Agent source code (8 agents: blacksmith, coder, demo, git-flow, json-viewer, librarian, sql, todo)
- `scripts/` - Runtime scripts for tool execution
- `tools/`, `utils/`, `mcp/`, `docs/` - Source organization

## Integration Points
- MCP Bridge server exposes 19 basic-memory functions
- Public API at https://tools.skogai.se/tools
- Links to aichat functions directory
- Multi-language support: bash, node, python

## Environment Variable
`SKOGAI_ARGC=/home/skogix/skogai/tools/Argcfile.sh`