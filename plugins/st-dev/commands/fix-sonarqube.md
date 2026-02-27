---
description: Fetch open SonarQube issues and fix them
---

# Fix SonarQube Issues

You are fixing SonarQube issues for this project. Follow these steps precisely.

## Step 1: Read or Create Configuration

Check if the file `.claude/sonarqube.local.md` exists in the current project.

### If it exists:
Read the file and parse the YAML frontmatter to get `sonarqube_url`, `token`, and `projects` list.

### If it does NOT exist:
Guide the user through creating the config interactively:

1. Use `AskUserQuestion` to ask for the SonarQube server URL:
   - question: "What is the SonarQube server URL?"
   - options: `[{"label": "https://sonar.amk-tpt.de", "description": "TPT SonarQube"}, {"label": "https://sonarcloud.io", "description": "SonarCloud"}]`

2. Use `AskUserQuestion` to ask for the authentication token:
   - question: "What is your SonarQube token? (will be stored locally in .claude/sonarqube.local.md, which is gitignored)"
   - Let the user enter it via "Other"
   - options: `[{"label": "I'll enter it", "description": "Type or paste the token"}]`

3. Use the Bash tool to list available projects from SonarQube:
   ```
   curl -s -u <TOKEN>: "<SONARQUBE_URL>/api/projects/search?ps=50" | jq '.components[] | {key, name}'
   ```
   Use `AskUserQuestion` with `multiSelect: true` to let the user pick which projects to include. Build options from the API response.

4. Write the `.claude/sonarqube.local.md` file with the collected information:
   ```markdown
   ---
   sonarqube_url: <URL>
   token: <TOKEN>
   projects:
     - name: <Project Name>
       key: <project-key>
   ---

   # SonarQube Configuration

   This file contains the SonarQube connection details for the `/fix-sonarqube` command.
   Do NOT commit this file — `.claude/` is in `.gitignore`.

   To add more projects, append entries to the `projects` list in the frontmatter above.
   ```

5. Confirm to the user that the config was created, then continue with Step 2.

## Step 2: Select Project

If there is only one project in the `projects` list, use it automatically and tell the user which project was selected.

If there are multiple projects, use the `AskUserQuestion` tool to ask the user which project to check. Build the options dynamically from the `projects` list in the config:

- Each option's `label` should be the project `name`
- Each option's `description` should show the project `key`

Use the selected project's `key` as `<PROJECT_KEY>` for all subsequent API calls.

## Step 3: Check Quality Gate Status

Use the Bash tool to call the SonarQube REST API:

```
curl -s -u <TOKEN>: "<SONARQUBE_URL>/api/qualitygates/project_status?projectKey=<PROJECT_KEY>" | jq .
```

Display the quality gate status clearly:
- If **PASSED**: show all conditions and their values
- If **ERROR**: highlight which conditions failed (e.g. duplicated lines density > threshold, coverage < threshold, new violations > 0)

## Step 4: Fetch Open Issues

```
curl -s -u <TOKEN>: "<SONARQUBE_URL>/api/issues/search?componentKeys=<PROJECT_KEY>&statuses=OPEN,CONFIRMED&ps=100&p=1" | jq .
```

If there are more than 100 issues (check `total` in response), paginate by incrementing `p` until all issues are fetched.

## Step 5: Display Summary

### Quality Gate Conditions
Show a table of all quality gate conditions with status (PASSED/FAILED), metric, threshold, and actual value.

### Open Issues
Group the issues by severity and display a summary table:

1. **BLOCKER** — Must fix immediately
2. **CRITICAL** — Must fix
3. **MAJOR** — Should fix
4. **MINOR** — Nice to fix
5. **INFO** — Informational

For each issue, show:
- File path and line number
- Rule key (e.g. `typescript:S1234`)
- Message describing the problem

## Step 6: Fix Issues and Failed Conditions

### Fix Open Issues
Work through the issues starting with BLOCKER, then CRITICAL, MAJOR, MINOR:

1. Read the affected file
2. Understand the issue based on the rule and message
3. Apply the fix using the Edit tool
4. Move to the next issue

When multiple issues affect the same file, fix them all at once before moving to the next file.

### Fix Failed Quality Gate Conditions
For each failed condition, investigate and fix the root cause:

- **new_duplicated_lines_density** (duplicated lines too high): Use the API to find which files have new duplications:
  ```
  curl -s -u <TOKEN>: "<SONARQUBE_URL>/api/measures/component_tree?component=<PROJECT_KEY>&metricKeys=new_duplicated_lines_density&s=metricPeriod&metricPeriodSort=1&metricSort=new_duplicated_lines_density&metricSortFilter=withMeasuresOnly&asc=false&ps=10&qualifiers=FIL" | jq .
  ```
  Then use the duplications API to see exact duplicate blocks:
  ```
  curl -s -u <TOKEN>: "<SONARQUBE_URL>/api/duplications/show?key=<COMPONENT_KEY>" | jq .
  ```
  Refactor the duplicated code by extracting shared helpers, constants, or functions.

- **new_coverage** (test coverage too low): Identify uncovered new code and add tests.

- **new_violations** (new issues introduced): These should already be covered by the open issues fix above.

## Step 7: Verify

After all fixes are applied, detect the project type and run the appropriate build:
- If `pom.xml` exists → `mvn clean compile`
- If `package.json` exists → `npm run build`

If the build fails, fix the build errors before finishing.

## Step 8: Summary

Provide a summary of:
- Quality gate status and which conditions were addressed
- How many issues were fixed, grouped by severity
- Which files were modified
- Whether the build succeeded