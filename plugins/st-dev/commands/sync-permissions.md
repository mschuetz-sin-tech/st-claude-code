---
description: Sync useful project permissions to global settings. Trigger phrases include "sync permissions", "global permissions", "permission sync".
---

Sync project-local permissions to global Claude Code settings.

## Instructions

### Step 1: Read Both Settings Files

1. Read `.claude/settings.local.json` from the current project directory using the Read tool
2. Read `~/.claude/settings.json` (global settings) using the Read tool
3. Extract the `permissions.allow` arrays from both files
4. If `.claude/settings.local.json` does not exist or has no permissions, inform the user and stop

### Step 2: Filter One-Time Permissions

Remove project permissions that are clearly one-time or path-specific and not useful globally:

- **Exact git commits**: Permissions containing a full `git commit -m` with a specific commit message (e.g. `Bash(git commit -m "$(cat <<'EOF'...`)
- **Path-specific commands**: Permissions containing absolute paths to specific project directories (e.g. `Bash(git -C "C:\\Users\\...` or similar)
- **Other overly specific entries**: Single-use commands that reference specific file names, specific error messages, or session-specific context

Keep permissions that use wildcards (e.g. `Bash(git rm:*)`) or are generic tool invocations (e.g. `mcp__ide__getDiagnostics`, `WebFetch(domain:...)`).

### Step 3: Compute the Difference

For each remaining project permission, check if it is already covered by the global permissions:

**Wildcard coverage rules:**
- `Bash(git:*)` covers `Bash(git add:*)`, `Bash(git commit:*)`, `Bash(git rm:*)`, etc.
- `Bash(mvn:*)` covers `Bash(mvn clean:*)`, `Bash(mvn test:*)`, etc.
- `Bash(npm:*)` covers `Bash(npm install:*)`, `Bash(npm run:*)`, etc.
- General rule: `Bash(X:*)` covers `Bash(X Y:*)` and `Bash(X Y Z:*)` for any subcommands Y, Z
- Exact string matches are also considered covered

Only keep permissions that are NOT already covered by existing global permissions.

### Step 4: Present Missing Permissions

If there are no missing permissions, inform the user that everything is already synced and stop.

Otherwise, present the missing permissions to the user using `AskUserQuestion`:
- Show each missing permission as a selectable option
- Use `multiSelect: true` so the user can pick multiple
- The label should be the permission string itself
- The description should briefly explain what it allows

### Step 5: Update Global Settings

For each permission the user selected:
1. Read `~/.claude/settings.json` again (to get the latest state)
2. Add the selected permissions to the `permissions.allow` array
3. Write the updated file using the Edit tool (prefer Edit over Write to preserve formatting)

### Step 6: Report Result

Report a summary:
- How many permissions were added
- List the added permissions
- Note if any were skipped (already covered or filtered as one-time)
