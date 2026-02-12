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

### 4. Analyze and Load Required Skills

Before implementing, analyze the ticket to determine which skills to load:

1. Read the ticket's technical details and acceptance criteria carefully
2. Identify ALL technologies and file types involved (Java classes, YAML configs, Angular components, Docker files, etc.)
3. List all available skills by scanning the plugin's skills directory and reading each skill's `description` frontmatter
4. Match the ticket's technologies against each available skill's description and trigger phrases
5. **Invoke ALL matching skills using the Skill tool BEFORE starting implementation** — even if only part of the ticket touches that technology. You MUST actually call the Skill tool for each matching skill, not just mentally note them.
6. If unsure whether a skill applies, invoke it — loading an extra skill is better than missing conventions
7. **Keep track of which skills you loaded** — you will need to report this at the end

Common skill mappings (non-exhaustive):
- Java files, pom.xml, application*.yml, Spring config → `spring-boot-dev`
- Angular components, services, TypeScript files → `angular-dev`
- Test files, test fixes, test verification → `spring-boot-testing`
- PR creation → `bitbucket-pr`

### 5. Implement the Ticket

- Analyze project structure
- Use planning mode
- Follow the ticket requirements exactly
- Apply conventions from ALL loaded skills
- Follow project conventions from CLAUDE.md
- Run tests to verify implementation

**CRITICAL — Plan must include post-implementation steps:**
When creating the plan, you MUST include the following steps as part of the plan itself (not just as mental notes). These steps are mandatory and must appear as explicit steps in the plan so they survive the plan-mode transition:

1. **Commit step**: Stage specific files (avoid `git add .`) and commit with conventional commit format:
   ```
   feat(T-XXX): short description

   Implements ticket T-XXX: <ticket title>

   ```
2. **Push step**: `git push -u origin feature/T-XXX-short-name`
3. **Create PR step**: Use the `bitbucket-pr` skill to create the PR via Bitbucket API. PR title format: `feat(T-XXX): <ticket title>`. PR description should include summary of changes, reference to ticket, and test plan.
4. **Report step**: Show PR URL, summary of what was implemented, which skills were loaded (and why), and any follow-up items.

