# Setup Worktree for GitHub Issue/PR

Create an isolated Git worktree in `.dev/worktree/` for working on a GitHub issue or PR. If no issue/PR exists, optionally create one first using `/create-issue`.

- [@tree:worktree]
- [@cat-script:worktree]
- @/.dev/worktree/
- @/.dev/worktree/
- @/.dev/worktree/


## Usage

- `/worktree` - Interactive mode: prompts for issue/PR selection or creation
- `/worktree <issue-number>` - Create worktree for existing issue #<issue-number>
- `/worktree <pr-number>` - Create worktree for existing PR #<pr-number>
- `/worktree new` - Create new issue first, then set up worktree

## Steps

### 1. Determine Target Issue/PR

**If $ARGUMENTS is provided:**
- Parse argument as issue/PR number (e.g., "123" or "#123" or "pr-123")
- Validate it exists using `gh issue view <number>` or `gh pr view <number>`
- If argument is "new", proceed to step 1b

**If no $ARGUMENTS:**
- List recent issues: `gh issue list --limit 10 --json number,title,state`
- List recent PRs: `gh pr list --limit 10 --json number,title,headRefName,state`
- Ask user:
  1. Select existing issue number
  2. Select existing PR number
  3. Create new issue (go to step 1b)
  4. Cancel

**Step 1b: Create new issue (if needed):**
- Run `/create-issue` command to gather requirements and create issue
- Wait for issue creation confirmation
- Store the new issue number for next steps

### 2. Fetch Issue/PR Metadata

**For Issues:**
```bash
gh issue view <number> --json number,title,body,labels,state,url
```

**For PRs:**
```bash
gh pr view <number> --json number,title,body,headRefName,baseRefName,state,url
```

Extract:
- Issue/PR number
- Title (for directory naming)
- Branch name (for PRs, or create from issue for issues)
- Labels (to include in directory name if relevant)

### 3. Generate Worktree Directory Name

**Format:** `.dev/worktree/<type>-<number>-<sanitized-title>`

- `<type>`: "issue" or "pr"
- `<number>`: Issue or PR number
- `<sanitized-title>`: Title converted to kebab-case, max 50 chars
  - Convert to lowercase
  - Replace spaces and special chars with hyphens
  - Remove consecutive hyphens
  - Truncate to 50 characters

**Example:**
- Issue #139 "lazy/manage/lock.lua:29: commit is nil"
- Becomes: `.dev/worktree/issue-139-lazy-manage-lock-lua-29-commit-is-nil`

### 4. Create Branch Name (for Issues)

**For PRs:** Use existing branch name from `headRefName`

**For Issues:** Generate branch name
- Format: `issue-<number>-<sanitized-title>` (max 60 chars)
- Example: `issue-139-lazy-manage-lock-lua-commit-nil`

### 5. Setup Worktree

**Check if worktree directory already exists:**
```bash
git worktree list | grep -q ".dev/worktree/<generated-name>"
```

If exists:
- Ask user:
  1. Navigate to existing worktree (skip creation)
  2. Remove and recreate worktree
  3. Cancel

**Create .dev/worktree directory if needed:**
```bash
mkdir -p .dev/worktree
```

**For PRs:**
```bash
# Checkout PR branch in worktree
gh pr checkout <pr-number> --detach
git worktree add .dev/worktree/<generated-name> <branch-name>
```

**For Issues:**
```bash
# Determine base branch (usually main or develop)
base_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

# Create worktree with new branch
git worktree add -b <branch-name> .dev/worktree/<generated-name> origin/$base_branch
```

### 6. Setup Development Environment in Worktree

**Navigate to worktree:**
```bash
cd .dev/worktree/<generated-name>
```

**Detect project type and initialize:**

Check for project indicators:
- JavaScript/TypeScript: `package.json` exists
- Python: `requirements.txt`, `pyproject.toml`, or `Pipfile` exists
- Ruby/Rails: `Gemfile` exists

**For JavaScript/TypeScript:**
```bash
npm install || yarn install || pnpm install
```

**For Python:**
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt || poetry install
```

**For Ruby/Rails:**
```bash
bundle install
```

**Ask if user wants to run additional setup:**
- Database migrations?
- Database seeding?
- Other custom setup commands?

### 7. Create Worktree Context File

Create `.dev/worktree/<generated-name>/.worktree-context.json`:
```json
{
  "type": "issue|pr",
  "number": <number>,
  "title": "<original title>",
  "url": "<github-url>",
  "branch": "<branch-name>",
  "base_branch": "<base-branch>",
  "created_at": "<timestamp>",
  "created_by": "claude-code",
  "labels": ["label1", "label2"]
}
```

### 8. Provide Summary

Output:
```
✓ Worktree created successfully!

Type: <Issue|PR>
Number: #<number>
Title: <title>
URL: <github-url>

Location: .dev/worktree/<generated-name>
Branch: <branch-name>

Dependencies installed: <yes|no>

Next steps:
1. cd .dev/worktree/<generated-name>
2. Start working on the issue/PR
3. Run: claude --continue

To list all worktrees:
  git worktree list

To remove when done:
  git worktree remove .dev/worktree/<generated-name>
```

## Cleanup Helper

**Optional: Ask if user wants to add cleanup alias:**
- Suggest creating git alias: `git worktree-clean` to remove merged worktrees
- Show command to list all worktrees: `git worktree list`

## Success Criteria

- [ ] Issue/PR number determined (existing or newly created)
- [ ] Metadata fetched from GitHub
- [ ] Directory name generated following format
- [ ] Branch name determined or created
- [ ] Worktree created at `.dev/worktree/<name>`
- [ ] Dependencies installed for detected project type
- [ ] Context file created with metadata
- [ ] Summary provided with next steps
- [ ] Current directory changed to new worktree (optional)

## Error Handling

- If GitHub CLI not authenticated: Show `gh auth login` instructions
- If issue/PR doesn't exist: Offer to create new issue
- If worktree already exists: Offer remove/recreate or navigate
- If branch already exists: Offer to use different branch name
- If dependency installation fails: Show error but don't fail worktree creation
- If .dev directory is gitignored: Verify .dev/worktree/ won't be committed

## Notes

- Uses `.dev/worktree/` to keep worktrees organized and gitignored
- Auto-detects project type for dependency installation
- Stores metadata for future reference and automation
- Follows kebab-case naming convention from CLAUDE.md
- Integrates with `/create-issue` for seamless workflow
- Preserves git history sharing across all worktrees
- Each worktree is completely isolated for parallel work