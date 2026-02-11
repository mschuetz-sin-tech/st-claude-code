---
description: Create a new local markdown ticket with Software Architect analysis. Analyzes the project, gathers requirements interactively, and creates structured tickets with code snippets. Trigger phrases include "create ticket", "new ticket", "add ticket", "create local ticket".
allowed_args: "[epic-name]"
---

Create a new local ticket in the project's `docs/tickets/` directory with proper structure, acceptance criteria, and technical details.

## Overview

This command acts as a **Software Architect** to:
1. Analyze the current project structure and conventions
2. Gather requirements interactively from the user
3. Evaluate if requirements should be split into multiple tickets
4. Create well-structured tickets with code snippets that follow project conventions

## Instructions

### 1. Project Analysis

Before creating any ticket, analyze the project to understand:

#### 1.1 Identify Project Type and Tech Stack

```bash
# Check for backend
ls pom.xml build.gradle package.json 2>/dev/null
# Check for frontend
ls angular.json vite.config.* next.config.* 2>/dev/null
# Check for existing conventions
ls CLAUDE.md .claude/settings.json 2>/dev/null
```

Read the `CLAUDE.md` or project README to understand project conventions.

#### 1.2 Analyze Existing Ticket Structure

```bash
# Find existing tickets
ls docs/tickets/*/T-*.md 2>/dev/null | head -10
# Find existing READMEs
ls docs/tickets/README.md docs/tickets/*/README.md 2>/dev/null
```

If tickets exist, read 2-3 examples to understand the current structure and style.

#### 1.3 Identify Available Skills

Read the skills directory to know which development skills can be invoked for code snippets:

```bash
ls "${CLAUDE_PLUGIN_ROOT}/skills/"
```

For each skill found, read its `skill.md` to understand what conventions it provides (e.g., Liquibase XML format, Angular Signals patterns).

### 2. Gather Requirements

Ask the user for:

1. **Description or Document**: Request a description of the feature/task, or a path to a document/PDF containing requirements
2. **Epic Assignment**: Which epic does this belong to? List existing epics from `docs/tickets/`

Use the AskUserQuestion tool to clarify:
- What is the main goal of this feature?
- Who is the target user (Coach, Member, System)?
- Are there any dependencies on existing features/tickets?
- What are the success criteria?

### 3. Software Architect Evaluation

After gathering requirements, evaluate from an architect's perspective:

#### 3.1 Complexity Analysis

Consider splitting the requirement into multiple tickets if:
- **Multiple User Flows**: Different user types need different implementations
- **Backend + Frontend**: Significant work in both layers (>3 hours each)
- **Independent Features**: Parts can be developed and tested separately
- **Risk Isolation**: Complex parts should be isolated to reduce PR scope
- **Database + API + UI**: Multiple architectural layers involved

#### 3.2 Dependency Analysis

- Identify if new tickets depend on existing ones
- Suggest implementation order
- Flag potential blockers

#### 3.3 Present Split Recommendation

If splitting is recommended:
```
## Architect Recommendation

Based on complexity analysis, I recommend splitting this into X tickets:

1. **T-XXX: [Title]** (~Y hours)
   - Scope: [Backend/Frontend/Both]
   - Dependencies: [None / T-XXX]
   - Focus: [Specific scope]

2. **T-XXX: [Title]** (~Y hours)
   ...

Reason: [Why this split makes sense]

Do you want to proceed with this split, or create as a single ticket?
```

### 4. Ticket Number Assignment

Determine the next ticket number:

```bash
# Find highest ticket number in the target epic
ls docs/tickets/epic-X-*/ 2>/dev/null | grep -oE "T-[0-9]+" | sort -V | tail -1
```

Increment appropriately:
- Epic 0: T-0XX
- Epic 1: T-1XX
- Epic 2: T-2XX
- etc.

### 5. Load Development Skills for Code Snippets

**CRITICAL**: Before writing code snippets, invoke the relevant development skills:

| Technology | Skill to Invoke |
|------------|-----------------|
| Spring Boot entities, services, controllers | `spring-boot-dev` |
| Liquibase migrations | `spring-boot-dev` (uses XML format!) |
| MapStruct mappers | `spring-boot-dev` |
| Angular components | `angular-dev` |
| Angular services, signals | `angular-dev` |
| Integration tests | `spring-boot-testing` |

Use the Skill tool to invoke each matching skill before generating code snippets. This ensures:
- Liquibase uses XML format (not YAML)
- Angular uses Signals and Standalone Components
- Spring Boot follows project conventions

### 6. Create Ticket File

Create the ticket following this structure:

```markdown
# T-XXX: [Ticket Title]

## Epic
Epic X - [Epic Name]

## Beschreibung
[Clear description of what needs to be implemented]

## Akzeptanzkriterien
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3
(Minimum 3 criteria, be specific and testable)

## Technische Details

### [Component/Entity/Service Name]
```[language]
[Code snippet following loaded skill conventions]
```

### [Another Component]
```[language]
[Code snippet]
```

## Abhängigkeiten
- T-XXX: [Dependency description]
- (or "Keine" if no dependencies)

## Aufwand
~X Stunden
```

### 7. Create Epic Directory (if needed)

If the epic directory doesn't exist:

```bash
mkdir -p docs/tickets/epic-X-name
```

### 8. Update README (if exists)

If `docs/tickets/README.md` exists, suggest updates:
- Add new ticket to epic overview
- Update implementation order if needed

### 9. Git Add

```bash
git add docs/tickets/epic-*/T-XXX-*.md
```

### 10. Report Summary

Present the created ticket(s):

```
## Created Ticket(s)

### T-XXX: [Title]
- File: `docs/tickets/epic-X-name/T-XXX-filename.md`
- Epic: Epic X - [Name]
- Estimated: ~X hours
- Dependencies: [List]

### Skills Used for Code Snippets
- spring-boot-dev: [What conventions were applied]
- angular-dev: [What conventions were applied]

### Next Steps
1. Review the ticket(s)
2. Use `/work-local-ticket T-XXX` to implement
```

## Ticket Naming Conventions

- Filename: `T-XXX-short-descriptive-name.md`
- Use lowercase and hyphens
- Keep filename under 50 characters
- Examples:
  - `T-100-user-entity.md`
  - `T-301-create-single-appointment.md`
  - `T-700-email-service-setup.md`

## Code Snippet Guidelines

When including code snippets:

1. **Always invoke the relevant skill first** to load conventions
2. **Keep snippets focused** - show the key implementation, not boilerplate
3. **Use realistic names** - match project naming conventions
4. **Include comments** explaining non-obvious parts
5. **Show relationships** - if entities relate, show both sides

## Quality Checklist

Before finalizing, verify:
- [ ] Acceptance criteria are specific and testable
- [ ] Code snippets follow loaded skill conventions
- [ ] Dependencies are correctly identified
- [ ] Effort estimate is realistic (consider complexity)
- [ ] Ticket is self-contained enough to implement and test independently
