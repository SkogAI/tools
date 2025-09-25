# Documentor Agent

A comprehensive documentation agent for the SkogAI ecosystem that integrates with basic-memory for knowledge management.

## Actions

- **generate_code_docs**: Analyze code and create technical documentation
- **generate_lore**: Chronicle system evolution and philosophy
- **index_memory**: Update memory system indices
- **review_docs**: Analyze existing documentation quality

## Usage

```bash
argc run@agent documentor generate_code_docs '{"path": "/path/to/code"}'
argc run@agent documentor generate_lore '{"topic": "System Evolution"}'
argc run@agent documentor index_memory '{"project": "skogai"}'
argc run@agent documentor review_docs '{"path": "/path/to/docs"}'
```

## Integration

- **SkogAI argc ecosystem**: Full integration with argc framework
- **Basic-memory**: Storage and retrieval of documentation artifacts
- **JSON interface**: Standardized agent communication pattern