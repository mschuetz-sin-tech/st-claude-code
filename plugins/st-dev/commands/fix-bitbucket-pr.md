---
description: Check open Bitbucket PRs for review comments and failed builds, then fix them. Trigger phrases include "fix Bitbucket PR", "Bitbucket review feedback", "Bitbucket PR review", "fix PR build", "fix pipeline".
allowed_args: "[pr-id]"
---

Check open Bitbucket Pull Requests for review comments and failed builds, checkout the branch, and fix the issues.

## Instructions

### 1. Find PRs with Issues

If a PR ID was provided as argument, use that PR directly and skip to step 2.

Otherwise, list open PRs authored by the current user:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-list-prs.sh"
```

For each PR found, check for unresolved comments AND failed builds:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-comments.sh" <PR_ID>
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-builds.sh" <PR_ID>
```

A PR needs fixing if it has:
- Unresolved inline comments from reviewers, OR
- Builds with `state` = `"FAILED"` or `"STOPPED"`

If **multiple PRs** need fixing, use `AskUserQuestion` to ask the user which PR to fix. Show each PR's ID, title, branch, and what issues it has (comments, failed build, or both).

If **no PRs** need fixing, report that and stop.

### 2. Analyze Issues

#### 2a. Comments

Filter comments to those that:
- Are NOT resolved (`.resolved == false`)
- Are inline comments (have `.file`)
- Are from reviewers (not from the PR author)

#### 2b. Failed Builds

For failed builds, the build log is typically available via Bitbucket Pipelines. Check the pipeline output to understand what failed:
- Compilation errors
- Test failures
- Linting errors

### 3. Checkout the Branch

```bash
BRANCH_NAME=$(bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-branch.sh" $PR_ID)

git fetch origin
git checkout $BRANCH_NAME
git pull origin $BRANCH_NAME
```

### 4. Address Review Comments

For each unresolved comment:

1. **Read the comment** - Understand what the reviewer is asking for
2. **Read the file** - Look at the code context around the commented line
3. **Make the fix** - Apply the requested change
4. **Verify** - Ensure the fix doesn't break anything

Group related comments together if they affect the same file.

### 5. Fix Build Failures

For each failed build:

1. **Read the build log** - Understand what failed (compilation, tests, lint)
2. **Identify the root cause** - Find the failing file(s) and error(s)
3. **Make the fix** - Apply the necessary changes
4. **Run the build/tests locally** - Verify the fix resolves the failure

### 6. Run Tests

After making all changes, verify nothing is broken:

```bash
# Detect project type and run appropriate tests
if [ -f "pom.xml" ]; then
  mvn test
elif [ -f "package.json" ]; then
  npm test
fi
```

### 7. Commit and Push

```bash
git add <modified-files>
git commit -m "fix: address PR review feedback

- <issue 1 summary>
- <issue 2 summary>

Co-Authored-By: Claude <noreply@anthropic.com>"

git push origin $BRANCH_NAME
```

### 8. Reply to Comments (Optional)

Reply to addressed comments to indicate they've been fixed:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-reply-comment.sh" $PR_ID $COMMENT_ID "Fixed in latest commit."
```

### 9. Report Result

Show:
- PR URL
- Number of comments addressed
- Number of build failures fixed
- Summary of changes made
- Any issues that couldn't be addressed automatically (with explanation)
