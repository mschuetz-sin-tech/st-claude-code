# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This repository contains Claude Code plugins for sin-tech development workflows. It provides skills, commands, and permissions for Spring Boot and Angular development.

## Repository Structure

```
plugins/st-dev/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (name, version, component paths)
├── skills/                   # Skill definitions (auto-discovered)
│   ├── spring-boot-dev/     # Spring Boot development patterns
│   ├── spring-boot-testing/ # Spring Boot testing patterns
│   └── angular-dev/         # Angular development patterns
├── commands/                 # Slash commands (auto-discovered)
│   ├── build.md             # /build - Build project and fix errors
│   ├── test.md              # /test - Run tests and fix failures
│   └── commit.md            # /commit - Create conventional commit
└── permissions.json          # Pre-approved bash commands for skills
```

## Adding New Components

### Adding a Skill

1. Create folder: `plugins/st-dev/skills/<skill-name>/`
2. Create `skill.md` with YAML frontmatter containing `description` (trigger phrases)
3. Skills are auto-discovered via the `"skills": "./skills/"` path in plugin.json

### Adding a Command

1. Create markdown file: `plugins/st-dev/commands/<command>.md`
2. Include instructions and expected output format
3. Commands are auto-discovered via the `"commands": "./commands/"` path in plugin.json

## Conventions

- All comments in English
- Use descriptive variable names
- All new files must be staged with `git add`
- Update README.md if changes affect documented features