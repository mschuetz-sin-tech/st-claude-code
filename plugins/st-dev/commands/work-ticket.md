---
description: Work on the next ticket - creates branch, implements, commits, pushes, and creates Bitbucket PR
allowed_args: "[ticket-id]"
---

Work on a ticket from the project's ticket directory.

## Instructions

### 1. Identify the Ticket

If a ticket ID was provided as argument (e.g., `T-001`), find that ticket.

Otherwise, list available tickets:

```bash
ls docs/tickets/*/T-*.md 2>/dev/null | head -20
```

Pick the next unimplemented ticket in sequence.

### 2. Read the Ticket

Read the full ticket file to understand:
- What needs to be implemented
- Acceptance criteria
- Dependencies on other tickets

### 3. Create Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/T-XXX-short-name
```

Branch naming: `feature/{ticket-id}-{short-description}`

### 4. Implement the Ticket

- Follow the ticket requirements exactly
- Use appropriate development skills (spring-boot-dev, angular-dev, etc.)
- Follow project conventions from CLAUDE.md
- Run tests to verify implementation

### 5. Commit Changes

Stage specific files (avoid `git add .`):

```bash
git add <specific-files>
git commit -m "feat(T-XXX): short description

Implements ticket T-XXX: <ticket title>

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 6. Push Branch

```bash
git push -u origin feature/T-XXX-short-name
```

### 7. Create Pull Request

Use the `bitbucket-pr` skill to create the PR via Bitbucket API.

PR title format: `feat(T-XXX): <ticket title>`

PR description should include:
- Summary of changes
- Reference to ticket
- Test plan

### 8. Report Result

Show:
- PR URL
- Summary of what was implemented
- Any notes or follow-up items
