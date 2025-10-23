# Librarian Agent - Usage Guide

Documentation viewing and management agent for `/home/skogix/skogai/docs/`

## Quick Examples

```bash
# List all markdown files recursively
argc run@agent librarian list_docs '{"pattern": "*.md", "recursive": true}'

# Show document summary
argc run@agent librarian summarize_doc '{"doc_path": "agents/documentation/README.md", "lines": 15}'

# Extract headers (level 1-2 only)
argc run@agent librarian show_headers '{"doc_path": "memory/dev/tool.md", "level": "2"}'

# Search for "argc" in headers only
argc run@agent librarian search_docs '{"query": "argc", "headers_only": true}'

# Show overall documentation statistics
argc run@agent librarian doc_stats '{}'
```

## All Available Commands

### list_docs
**Purpose**: List documentation files with optional filtering

**Parameters**:
- `pattern` (optional): File pattern like "*.md", "argc*"
- `type` (optional): "files", "dirs", or "all" (default: files)
- `recursive` (optional): Include subdirectories (boolean)

**Examples**:
```bash
argc run@agent librarian list_docs '{}'
argc run@agent librarian list_docs '{"pattern": "*.txt", "recursive": true}'
argc run@agent librarian list_docs '{"type": "dirs"}'
```

### summarize_doc
**Purpose**: Show document summary (first N lines + last 10 lines)

**Parameters**:
- `doc_path` (required): Path relative to /home/skogix/skogai/docs/
- `lines` (optional): Number of preview lines (default: 20)

**Examples**:
```bash
argc run@agent librarian summarize_doc '{"doc_path": "agents/documentation/README.md"}'
argc run@agent librarian summarize_doc '{"doc_path": "memory/dev/tool.md", "lines": 30}'
```

### show_headers
**Purpose**: Extract and display markdown headers

**Parameters**:
- `doc_path` (required): Path relative to /home/skogix/skogai/docs/
- `level` (optional): Show headers up to this level (1-6)

**Examples**:
```bash
argc run@agent librarian show_headers '{"doc_path": "agents/documentation/README.md"}'
argc run@agent librarian show_headers '{"doc_path": "memory/dev/tool.md", "level": "2"}'
```

### search_docs
**Purpose**: Search through documentation content

**Parameters**:
- `query` (required): Search term or pattern
- `headers_only` (optional): Search only in headers (boolean)
- `case_sensitive` (optional): Case-sensitive search (boolean)

**Examples**:
```bash
argc run@agent librarian search_docs '{"query": "argc"}'
argc run@agent librarian search_docs '{"query": "argc", "headers_only": true}'
argc run@agent librarian search_docs '{"query": "SkogAI", "case_sensitive": true}'
```

### doc_stats
**Purpose**: Show documentation statistics

**Parameters**:
- `doc_path` (optional): Specific document path, or omit for overall stats

**Examples**:
```bash
argc run@agent librarian doc_stats '{}'
argc run@agent librarian doc_stats '{"doc_path": "agents/documentation/README.md"}'
```

### read_official_documents
**Purpose**: Read official SkogAI documents

**Parameters**:
- `document` (required): Document name or "list" to see all

**Examples**:
```bash
argc run@agent librarian read_official_documents '{"document": "list"}'
argc run@agent librarian read_official_documents '{"document": "setup.md"}'
```

### fs_create
**Purpose**: Create files with path guarding

**Parameters**:
- `path` (required): Absolute file path
- `contents` (required): File contents

**Example**:
```bash
argc run@agent librarian fs_create '{"path": "/tmp/test.txt", "contents": "Hello World"}'
```

## Current Documentation Statistics

As of 2025-10-20:
- **Total files**: 3,000
- **Markdown files**: 798
- **Directories**: 524
- **Total lines**: 146,836
- **Total words**: 857,478

## Documentation Structure

```
/home/skogix/skogai/docs/
├── agents/          # Agent documentation
├── archives/        # Historical documentation
├── claude/          # Claude-specific notes
├── lore/            # Project lore and history
├── memory/          # Knowledge base (25+ domains)
├── official/        # Official documentation
├── prompts/         # Agent prompts and templates
└── todo/            # Task tracking
```

## Integration Notes

- Built using argc framework
- Follows SkogAI tool patterns
- All outputs go to `$LLM_OUTPUT`
- Uses proper argc comment tags
- JSON API for all parameters

## See Also

- `docs/references.txt` - Argc documentation references
- `Argcfile.sh` - Build system
- `agents/argc-expert/tools.sh` - Argc patterns and templates
- `tools/demo_sh.sh` - Basic tool example
