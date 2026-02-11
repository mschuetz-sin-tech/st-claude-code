# st-dev - sin-tech Development Plugin

Claude Code plugin for sin-tech development workflows with Spring Boot and Angular.

## Prerequisites

### Bitbucket Integration

The `bitbucket-pr` skill and `/work-local-ticket` command require Bitbucket API access.

**Required Environment Variables:**

| Variable | Description | Example |
|----------|-------------|---------|
| `BITBUCKET_USERNAME` | Your Bitbucket email | `user@sin-tech.de` |
| `BITBUCKET_APP_PASSWORD` | Bitbucket App Password | `ATBBxxxx...` |

**Setup on Windows (PowerShell as Admin):**

```powershell
[Environment]::SetEnvironmentVariable('BITBUCKET_USERNAME', 'your.email@sin-tech.de', 'User')
[Environment]::SetEnvironmentVariable('BITBUCKET_APP_PASSWORD', 'your-app-password', 'User')
```

**Creating a Bitbucket App Password:**

1. Go to Bitbucket > Personal Settings > App passwords
2. Click "Create app password"
3. Name: `Claude Code` (or similar)
4. Permissions required:
   - Repositories: Read, Write
   - Pull requests: Read, Write
5. Copy the generated password (shown only once)

## Commands

| Command | Description |
|---------|-------------|
| `/build` | Build project (Maven/npm) and fix compilation errors |
| `/test` | Run tests and fix failures |
| `/commit` | Create conventional commit for staged changes |
| `/create-commit-message` | Generate commit message without committing |
| `/fix-intellij-warnings` | Fix IDE warnings using IntelliJ diagnostics |
| `/work-local-ticket` | Full ticket workflow: branch, implement, commit, PR |
| `/fix-bitbucket-pr-comments` | Check open Bitbucket PRs for review comments and fix them |
| `/sync-permissions` | Sync useful project permissions to global settings |

### /work-local-ticket

Automates the complete ticket workflow:
1. Identifies the next open ticket from `docs/tickets/*/T-*.md`
2. Creates a feature branch
3. Implements the ticket requirements
4. Commits and pushes changes
5. Creates a Bitbucket Pull Request

**Usage:**
```
/work-local-ticket          # Work on next open ticket
/work-local-ticket T-003    # Work on specific ticket
```

**Required ticket structure:**
```
docs/
  tickets/
    sprint-1/
      T-001-setup-database.md
      T-002-user-auth.md
    sprint-2/
      T-003-api-endpoints.md
```

**How it detects completed tickets:**
- Checks git history for merged commits referencing ticket IDs
- Checks for existing feature branches

## Skills

| Skill | Trigger Phrases |
|-------|-----------------|
| `spring-boot-dev` | "implement endpoint", "create controller", "add service", "write repository" |
| `spring-boot-testing` | "run tests", "fix failing test", "write integration test", "MockMvc" |
| `angular-dev` | "Angular component", "Signal", "effect", "@for", "@if", "Angular Material" |
| `bitbucket-pr` | "create PR", "Bitbucket PR", "push and create PR" |

### bitbucket-pr

Creates Pull Requests via Bitbucket REST API.

**Features:**
- Auto-detects workspace and repo from git remote
- Creates PR with standardized template
- Supports branch naming conventions (`feature/`, `fix/`, `refactor/`, `docs/`)

**Requires:** Environment variables (see Prerequisites)

### /fix-bitbucket-pr-comments

Checks open Bitbucket PRs for review comments and fixes them:
1. Lists open PRs with unresolved comments
2. Fetches inline comments from reviewers
3. Checks out the PR branch
4. Addresses each comment
5. Runs tests to verify fixes
6. Commits and pushes changes

**Usage:**
```
/fix-bitbucket-pr-comments        # List open PRs and select one
/fix-bitbucket-pr-comments 123    # Fix comments on specific PR #123
```

**Requires:** Environment variables (see Prerequisites)

## Permissions

Pre-approved commands for automated workflows:

**Maven:**
- `mvn clean`, `compile`, `test`, `package`, `spring-boot:run`

**npm:**
- `npm install`, `build`, `test`, `start`

**git:**
- `git add`, `commit`, `push`, `checkout`, `branch`, `status`, `diff`, `log`
