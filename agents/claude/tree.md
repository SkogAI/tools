# Show Directory Tree

Display directory structure with LLM-optimized defaults.

Related: @.claude/commands/worktree.md

## Usage

- `/tree` - Show tree of current directory
- `/tree <path>` - Show tree of specified path

## Steps

### 1. Validate Input

Sanitize and validate the path argument:
- Default to current directory if no argument provided
- Check for forbidden characters: `; | & $ \` \ " ' < >`
- Prevent command substitution patterns
- Verify path exists and is a directory
- Ensure read permissions

### 2. Execute Tree Command

Run tree with secure, quoted arguments:

```bash
tree -L 3 -a -F --dirsfirst \
  -I '.git|node_modules|.venv|__pycache__|*.pyc|.next|dist|build|coverage|.cache|vendor|target|out' \
  --gitignore \
  "${validated_path}"
```

**Flags explained:**
- `-L 3` - Depth 3 (balances detail with readability for LLM context)
- `-a` - Show hidden files
- `-F` - Append file type indicators (/, *, @)
- `--dirsfirst` - List directories before files
- `-I` - Ignore common build artifacts and dependencies
- `--gitignore` - Respect .gitignore patterns

### 3. Handle Errors

If tree not installed, suggest installation:
- Arch: `sudo pacman -S tree`
- Debian/Ubuntu: `sudo apt install tree`
- macOS: `brew install tree`

## Example

```
/tree lua

lua/
├── config/
│   ├── keymaps.lua
│   └── options.lua
├── plugins/
│   ├── claude-code.lua
│   └── init.lua
└── init.lua

2 directories, 5 files
```

## Notes

- Depth 3 balances detail with context window limits
- Automatically filters development artifacts
- Path validation prevents command injection
- All variables must be quoted for security
