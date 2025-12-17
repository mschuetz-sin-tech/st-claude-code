---
description: This skill should be used when writing or fixing Spring Boot integration tests, analyzing test failures, or verifying new features. Trigger phrases include "run tests", "fix failing test", "write integration test", "test the feature", "MockMvc", "test failure", "AssertJ", "@SpringBootTest". Should be invoked after spring-boot-dev implements new features.
---

# Spring Boot Testing Skill

You are an expert in Spring Boot integration testing. This skill should be invoked after the spring-boot-dev skill implements new features to verify the implementation with tests.

## When to Invoke This Skill

- After implementing new features with spring-boot-dev
- When tests fail after code changes
- When refactoring existing test code
- When writing new integration tests

## Test Failure Analysis Workflow

When tests fail after code changes, follow this decision tree:

### Step 1: Identify the Failure Type

1. **Compile Error**: Code structure changed (renamed class, method signature changed)
2. **Runtime Error**: Null pointer, missing bean, configuration issue
3. **Assertion Failure**: Test expectation doesn't match actual result

### Step 2: Determine Root Cause

For **Assertion Failures**, check:

1. **Was there a breaking change in business logic?**
   - Did the feature requirements change?
   - Did the API response structure change intentionally?
   - Did validation rules change?

2. **Is the test testing the wrong thing?**
   - Is the test too tightly coupled to implementation details?
   - Is the test asserting on unstable values (timestamps, auto-generated IDs)?

3. **Is the code buggy?**
   - Does the new code have a bug that the test correctly caught?
   - Did a refactoring accidentally change behavior?

### Step 3: Decision - Fix Test or Fix Code?

**Fix the TEST when:**
- The business logic intentionally changed (breaking change)
- The test was asserting on implementation details that changed
- The test was too brittle (e.g., checking exact error messages)
- New features added new fields/behavior that tests didn't account for
- The test setup was incomplete or incorrect

**Fix the CODE when:**
- The test correctly identifies a bug
- The new code breaks existing contract/behavior that should be preserved
- A refactoring accidentally changed behavior
- Edge cases are not handled properly

## Test Best Practices

### Use DTO-Based Assertions (Not JSONPath)

**Bad - String-based assertions are brittle:**
```java
mockMvc.perform(post("/api/compound-deliveries/commit")
        .contentType(MediaType.APPLICATION_JSON)
        .content(objectMapper.writeValueAsString(request)))
    .andExpect(status().isOk())
    .andExpect(jsonPath("$.success").value(false))
    .andExpect(jsonPath("$.message").value(containsString("Fehler")));
```

**Good - DTO-based assertions with proper typing:**
```java
CommitResponse response = performPost("/api/compound-deliveries/commit", request, CommitResponse.class);
assertThat(response.isSuccess()).isFalse();
assertThat(response.getMessage()).contains("Fehler");
```

### Use Explicit Types (Not `var`)

**Bad - Type is unclear:**
```java
var result = mockMvc.perform(...).andReturn();
var response = objectMapper.readValue(result.getResponse().getContentAsString(), CommitResponse.class);
```

**Good - Types are explicit:**
```java
MvcResult result = mockMvc.perform(...).andReturn();
CommitResponse response = objectMapper.readValue(result.getResponse().getContentAsString(), CommitResponse.class);
```

### Centralize Request/Response Helpers

Create generic helper methods in your base test class:

```java
protected <T> T performPost(String url, Object requestBody, Class<T> responseClass) throws Exception {
    MvcResult result = mockMvc.perform(post(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.writeValueAsString(requestBody)))
            .andExpect(status().isOk())
            .andReturn();

    return objectMapper.readValue(
            result.getResponse().getContentAsString(),
            responseClass);
}

protected <T> T performGet(String url, Class<T> responseClass) throws Exception {
    MvcResult result = mockMvc.perform(get(url))
            .andExpect(status().isOk())
            .andReturn();

    return objectMapper.readValue(
            result.getResponse().getContentAsString(),
            responseClass);
}
```

### Test Isolation

- Use `@BeforeEach` to clean up test data before each test
- Don't rely on test execution order
- Each test should set up its own required data

```java
@BeforeEach
void cleanUpStagingTable() {
    compoundDeliveryRepository.deleteAll();
}
```

### Handle Batch Insert Edge Cases

When using batch/native SQL inserts, entities won't have IDs populated:

**Wrong - IDs are null after batch insert:**
```java
List<Entity> uploaded = service.processFile(file);
Long id = uploaded.get(0).getId(); // NULL!
```

**Correct - Query repository to get entities with IDs:**
```java
List<Entity> uploaded = service.processFile(file);
List<Entity> dbEntities = repository.findAll();
Long id = dbEntities.get(0).getId(); // Has ID
```

## Integration Test Structure

### Base Test Class

```java
@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureMockMvc
public abstract class AbstractControllerIntegrationTest {

    @Autowired
    protected MockMvc mockMvc;

    @Autowired
    protected ObjectMapper objectMapper;

    @BeforeEach
    void cleanUp() {
        // Clean staging data for test isolation
    }

    // Generic helper methods
    protected <T> T performPost(String url, Object body, Class<T> responseClass) throws Exception { ... }
    protected <T> T performGet(String url, Class<T> responseClass) throws Exception { ... }
}
```

### Test Class Structure

```java
@DisplayName("UC5: Commit to Production")
class CompoundDeliveryCommitIntegrationTest extends AbstractControllerIntegrationTest {

    @Test
    @DisplayName("UC5.1: Commit valid records should succeed")
    void commitValidRecordsShouldSucceed() throws Exception {
        // Given - Set up test data
        uploadTestData();
        setValidationStates();

        // When - Execute action
        CommitRequest request = createCommitRequest();
        CommitResponse response = performPost("/api/commit", request, CommitResponse.class);

        // Then - Assert results
        assertThat(response.isSuccess()).isTrue();
        assertThat(response.getShipmentsCreated()).isPositive();
    }
}
```

## Common Test Commands

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=CompoundDeliveryCommitIntegrationTest

# Run integration tests only
mvn test -Dtest=*IntegrationTest

# Run tests with verbose output
mvn test -X
```

## Checklist After Implementing Features

1. [ ] Run existing tests: `mvn test`
2. [ ] If tests fail, analyze using the workflow above
3. [ ] Write new tests for new functionality
4. [ ] Use DTO-based assertions with explicit types
5. [ ] Ensure test isolation (clean up in @BeforeEach)
6. [ ] Don't duplicate code - use/extend base class helpers
