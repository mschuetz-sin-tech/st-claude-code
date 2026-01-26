Generate a concise but informative commit message for uncommitted changes.

## Instructions

1. Run `git status` to see all staged and unstaged changes
2. Run `git diff --staged` to see staged changes (if any)
3. Run `git diff` to see unstaged changes
4. Run `git log -3 --format="%s%n%b"` to match recent commit style
5. Analyze ALL changes thoroughly and create a detailed commit message

## Commit Message Format

Follow conventional commits with a concise body:

```
<type>(<scope>): <short summary>

<1-2 sentence description of what changed and why>

Changes:
- <change 1>
- <change 2>
- <change 3>
```

### Length Guidelines
- **Body description**: 1-2 sentences maximum, focus on the WHY
- **Changes list**: 3-5 bullet points (group related changes together)
- **Total message**: Should fit comfortably in a terminal window (~15-20 lines max)
- Avoid repeating information between body and changes list
- Skip trivial details (imports, minor refactors) unless they're the main change

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
- **Body**: Explain WHAT changed and WHY in 1-2 sentences
- **Changes list**: Group related changes, mention components/layers affected (e.g. "Backend: ...", "Frontend: ...")

## Output

Present the commit message with a brief intro for easy copying:

"Here's your commit message:"

```
<the message>
```

Do NOT stage or commit the changes - only generate and output the message.