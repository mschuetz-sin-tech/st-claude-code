# sin-tech Claude Code Plugins

Claude Code Plugins for sin-tech development workflows.

## Installation

### Via Claude Code

```bash
# Add marketplace (once)
/plugin marketplace add mschuetz-sin-tech/st-claude-code

# Install plugin
/plugin install st-dev@sin-tech
```

### Manual Installation

Clone the repository and configure permissions manually:

```bash
git clone https://github.com/mschuetz-sin-tech/st-claude-code.git ~/.claude/plugins/st-dev
```

## Available Plugins

### st-dev

Development plugin for sin-tech projects with Spring Boot and Angular.

#### Skills

| Skill | Description |
|-------|-------------|
| `spring-boot-dev` | Spring Boot 3, Java 21, JPA, Liquibase, MapStruct |
| `spring-boot-testing` | Spring Boot integration testing, MockMvc, AssertJ |
| `angular-dev` | Angular 21, standalone components, signals, Material |
| `bitbucket-pr` | Create Pull Requests via Bitbucket API |

#### Commands

| Command | Description |
|---------|-------------|
| `/build` | Build the project and fix errors |
| `/test` | Run tests and fix failures |
| `/commit` | Create a well-formatted commit message |
| `/create-commit-message` | Generate commit message without committing |
| `/fix-intellij-warnings` | Fix IntelliJ warnings and errors before commit |
| `/work-local-ticket` | Full ticket workflow: branch, implement, commit, PR |
| `/fix-bitbucket-pr-comments` | Check open Bitbucket PRs for review comments and fix them |
| `/sync-permissions` | Sync useful project permissions to global settings |

See [plugins/st-dev/README.md](plugins/st-dev/README.md) for detailed documentation.

## Updating

To get the latest version:

```bash
/plugin install st-dev@sin-tech
```

Or if manually installed:

```bash
cd ~/.claude/plugins/st-dev && git pull
```

## Versioning

Version numbers are automatically incremented via GitHub Actions on push to main.

**PR Merge:** Requires label `minor` or `bug`
- `minor` → 1.0.0 → 1.1.0
- `bug` → 1.0.0 → 1.0.1

**Direct Push:** Always increments minor version.

## Development

### Adding a new skill

1. Create folder under `plugins/st-dev/skills/<skill-name>/`
2. Add `skill.md` with skill instructions
3. Update `plugin.json` to include the new skill

### Adding a new command

1. Create markdown file under `plugins/st-dev/commands/<command>.md`
2. Update `plugin.json` to include the new command

## License

Proprietary - sin-tech
