Generate a concise commit message for uncommitted changes.

## Instructions

1. Run `git status` to see all staged and unstaged changes
2. Run `git diff --staged` to see staged changes
3. Run `git diff` to see unstaged changes
4. Run `git log --oneline -5` to match recent commit style
5. Analyze the changes and create a commit message following conventional commits:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `refactor:` for code refactoring
   - `docs:` for documentation
   - `test:` for tests
   - `chore:` for maintenance

## Output

Only output the commit message, nothing else. Keep it concise (max 72 chars).

Format:
```
<type>: <short description>
```

Do NOT stage or commit the changes - only generate and output the message.
