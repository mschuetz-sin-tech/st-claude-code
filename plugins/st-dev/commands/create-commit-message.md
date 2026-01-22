Generate a comprehensive commit message for uncommitted changes.

## Instructions

1. Run `git status` to see all staged and unstaged changes
2. Run `git diff --staged` to see staged changes (if any)
3. Run `git diff` to see unstaged changes
4. Run `git log -3 --format="%s%n%b"` to match recent commit style
5. Analyze ALL changes thoroughly and create a detailed commit message

## Commit Message Format

Follow conventional commits with a detailed body:

```
<type>(<scope>): <short summary>

<detailed description of what changed and why>

Changes:
- <specific change 1>
- <specific change 2>
- ...
```

### Types
- `feat:` new features
- `fix:` bug fixes
- `refactor:` code refactoring
- `docs:` documentation
- `test:` tests
- `chore:` maintenance
- `style:` formatting, styling

### Guidelines
- **Summary line**: Max 72 chars, imperative mood ("Add feature" not "Added feature")
- **Scope**: Optional, e.g. `feat(frontend):` or `fix(api):`
- **Body**: Explain WHAT changed and WHY, not just HOW
- **Changes list**: Group related changes, be specific about files/components affected
- For UI changes: mention affected components and visual changes
- For API changes: mention endpoints and request/response changes
- For refactoring: explain the before/after structure

## Output

Present the commit message with a brief intro for easy copying:

"Here's your commit message:"

```
<the message>
```

Do NOT stage or commit the changes - only generate and output the message.