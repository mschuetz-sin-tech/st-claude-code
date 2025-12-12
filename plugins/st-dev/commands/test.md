Run tests and fix any failures.

## Instructions

1. Detect the project type:
   - If `pom.xml` exists → Maven project
   - If `package.json` exists → Node/Angular project

2. Run the appropriate test command:
   - Maven: `mvn test`
   - Node: `npm run test`

3. If tests fail:
   - Analyze the failure output
   - Identify the root cause
   - Fix the failing tests or the code causing the failure
   - Re-run tests to verify the fix

4. Continue until all tests pass

## Expected Output

Report:
- Total tests run
- Tests passed
- Tests failed (if any)
- What was fixed (if anything)
