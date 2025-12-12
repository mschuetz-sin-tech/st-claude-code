Build the project and fix any compilation errors.

## Instructions

1. Detect the project type:
   - If `pom.xml` exists → Maven project
   - If `package.json` exists → Node/Angular project

2. Run the appropriate build command:
   - Maven: `mvn clean compile` (or `mvn clean package` for full build)
   - Node: `npm run build`

3. If build fails:
   - Analyze the error output
   - Fix compilation errors, type errors, or missing dependencies
   - Re-run build to verify the fix

4. Continue until build succeeds

## Expected Output

Report:
- Build status (success/failure)
- Errors fixed (if any)
- Warnings (if relevant)
