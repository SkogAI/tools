# Create GitHub Issue

Investigate the current project and git state to create a well-formatted GitHub issue.

## Steps

1. **Investigate project context**
   - Run `git status` to see current branch and uncommitted changes
   - Run `git log --oneline -10` to see recent commits
   - Run `git branch -a` to see all branches
   - Check if there are any existing issues with `gh issue list --limit 20`
   - Look for issue templates in `.github/ISSUE_TEMPLATE/`
   - Read `README.md`, `CONTRIBUTING.md`, or `CLAUDE.md` for project conventions

2. **Gather issue details from user**
   - Ask the user for:
     1. Issue title (short, descriptive)
     2. Issue type (bug, feature, enhancement, documentation, etc.)
     3. Description of the issue or feature request
     4. Steps to reproduce (if bug)
     5. Expected vs actual behavior (if bug)
     6. Any relevant context or files
     7. Labels to apply (suggest based on project's existing labels)
     8. Assignees (optional)
     9. Milestone (optional)

3. **Format the issue**
   - Follow any issue template found in `.github/ISSUE_TEMPLATE/`
   - If no template exists, use a standard format:
     - Title
     - Type/Category
     - Description
     - Steps to Reproduce (for bugs)
     - Expected Behavior
     - Actual Behavior
     - Environment (git branch, commit, OS, etc.)
     - Additional Context
     - Proposed Solution (for features)
   - Include relevant code snippets or file references
   - Add current branch and commit SHA for context

4. **Review and create**
   - Show the formatted issue to the user for review
   - Ask for confirmation or modifications
   - Create the issue using `gh issue create` with:
     - Title: `--title "Issue Title"`
     - Body: `--body "Formatted content"`
     - Labels: `--label bug,enhancement` (if applicable)
     - Assignees: `--assignee username` (if applicable)
   - Provide the issue URL after creation

5. **Optional: Link to current work**
   - Ask if the user wants to reference this issue in:
     - Current branch name (suggest creating a new branch like `issue-123-description`)
     - Commit messages (suggest format like `fixes #123` or `refs #123`)

## Success Criteria

- [ ] Project context gathered from git status and history
- [ ] User provided all necessary issue details
- [ ] Issue follows project conventions or templates
- [ ] Issue created successfully on GitHub
- [ ] Issue URL returned to user
- [ ] Optional: Branch or commit references set up

## Notes

- Use `gh` CLI tool for GitHub operations
- Respect existing issue templates and labels
- Include git context (branch, commit SHA) for reproducibility
- Suggest relevant labels based on project's existing label set
