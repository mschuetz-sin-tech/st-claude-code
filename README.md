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
| `angular-dev` | Angular 19, standalone components, signals, Material |

#### Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create a well-formatted commit message |
| `/test` | Run tests and fix failures |
| `/build` | Build the project and fix errors |

## Updating

To get the latest version:

```bash
/plugin install st-dev@sin-tech
```

Or if manually installed:

```bash
cd ~/.claude/plugins/st-dev && git pull
```

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
