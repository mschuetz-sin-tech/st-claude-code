Fix IntelliJ IDEA warnings and errors before commit/push.

## Instructions

1. Use the `mcp__ide__getDiagnostics` tool to get all current warnings and errors from the IDE
2. Analyze the diagnostics and group them by file type:
   - Java files (*.java) → Use `spring-boot-dev` skill
   - TypeScript/Angular files (*.ts, *.html) → Use `angular-dev` skill
3. For each warning/error:
   - Read the affected file
   - Understand the issue from the diagnostic message
   - Apply the appropriate fix following the skill guidelines
   - Verify the fix doesn't break other code
4. After fixing, run `mcp__ide__getDiagnostics` again to verify all issues are resolved

## Skill Usage

Invoke the appropriate skill before fixing:
- For Java issues: Use the `spring-boot-dev` skill
- For Angular/TypeScript issues: Use the `angular-dev` skill

## Common IntelliJ Warnings

### Java
- Unused imports → Remove them
- Unused variables → Remove or use them
- Missing annotations → Add required annotations
- Null safety issues → Add null checks or @Nullable/@NonNull
- Deprecated API usage → Replace with modern alternatives

### Angular/TypeScript
- Unused imports → Remove them
- Type errors → Fix type definitions
- Strict null checks → Add proper null handling
- Template errors → Fix bindings and syntax

## Output

For each fix, briefly report:
- File: `<filename>`
- Issue: `<warning/error message>`
- Fix: `<what was changed>`

At the end, confirm all warnings and errors have been resolved.
