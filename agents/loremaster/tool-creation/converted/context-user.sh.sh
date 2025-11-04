```bash
#!/usr/bin/env bash
"$SKOGAI_DOT_FOLDER"/scripts/context-start.sh "user"
cat "$SKOGAI_DOT_FOLDER"/docs/user.md
"$SKOGAI_DOT_FOLDER"/scripts/context-end.sh "user"
"$SKOGAI_DOT_FOLDER"/scripts/context-start.sh "skogix"
cat "$SKOGAI_DOT_FOLDER"/docs/skogix.md
"$SKOGAI_DOT_FOLDER"/scripts/context-end.sh "skogix"
```

