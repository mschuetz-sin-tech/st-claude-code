---
description: Work on a local markdown ticket from docs/tickets/. Creates branch, implements, commits, pushes, and creates Bitbucket PR. Trigger phrases include "work ticket", "next ticket", "implement ticket".
allowed_args: "[ticket-id]"
---

Work on a local markdown ticket from the project's `docs/tickets/` directory.

**Note:** This command only works with local ticket files (e.g., `docs/tickets/sprint-1/T-001.md`), not external ticket systems like Jira.

## Instructions

### 1. Identify the Ticket

If a ticket ID was provided as argument (e.g., `T-001`), find that ticket.

Otherwise, determine which tickets are still open:

#### 1.1 List all tickets

```bash
ls docs/tickets/*/T-*.md 2>/dev/null | head -20
```

#### 1.2 Find already completed tickets

Check which tickets have been merged into main:

```bash
git log --oneline main | grep -oE "T-[0-9]+" | sort -u
```

#### 1.3 Find tickets currently in progress

Check for existing feature branches:

```bash
git branch -a | grep -oE "feature/T-[0-9]+" | grep -oE "T-[0-9]+" | sort -u
```

#### 1.4 Select the next open ticket

Compare the lists to find tickets that are:
- NOT in the merged commits list (not completed)
- NOT in the active branches list (not in progress)

Pick the lowest numbered ticket that meets both criteria.

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

### 4. Analyze Required Skills

Before implementing, analyze the ticket to determine which skills to load:

1. Read the ticket's technical details and acceptance criteria carefully
2. Identify ALL technologies and file types involved (Java classes, YAML configs, Angular components, Docker files, etc.)
3. List all available skills by scanning the plugin's skills directory and reading each skill's `description` frontmatter
4. Match the ticket's technologies against each available skill's description and trigger phrases
5. **Invoke ALL matching skills BEFORE starting implementation** — even if only part of the ticket touches that technology
6. If unsure whether a skill applies, invoke it — loading an extra skill is better than missing conventions

### 5. Implement the Ticket

- Analyze project structure
- Use planning mode
- Follow the ticket requirements exactly
- Apply conventions from ALL loaded skills
- Follow project conventions from CLAUDE.md
- Run tests to verify implementation
- At the end, report which skills you loaded and why

### 6. Commit Changes

Stage specific files (avoid `git add .`):

```bash
git add <specific-files>
git commit -m "feat(T-XXX): short description

Implements ticket T-XXX: <ticket title>

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 7. Push Branch

```bash
git push -u origin feature/T-XXX-short-name
```

### 8. Create Pull Request

Use the `bitbucket-pr` skill to create the PR via Bitbucket API.

PR title format: `feat(T-XXX): <ticket title>`

PR description should include:
- Summary of changes
- Reference to ticket
- Test plan

### 9. Report Result

Show:
- PR URL
- Summary of what was implemented
- Any notes or follow-up items
