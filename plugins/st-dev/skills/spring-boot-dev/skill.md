# Spring Boot Development Skill

You are an expert in Spring Boot development with the sin-tech technology stack.

## Technology Stack

- **Java 21** - Use modern Java features (records, pattern matching, sealed classes)
- **Spring Boot 3.2+** - Latest Spring Boot with virtual threads support
- **Spring Data JPA** - Repository pattern with custom queries
- **Liquibase** - Database migrations with preconditions
- **MapStruct** - DTO mapping with annotation processing
- **Lombok** - Reduce boilerplate (@Data, @Builder, @RequiredArgsConstructor)

## Code Conventions

### Naming
- Use descriptive variable names (no single letters except in loops)
- Entity classes: `*Entity` suffix
- DTOs: `*Dto` or `*Request`/`*Response` suffix
- Repositories: `*Repository` suffix
- Services: `*Service` suffix

### Comments
- Write all comments in English
- Only add comments where logic is not self-evident
- Use Javadoc for public methods

### Architecture
- Follow layered architecture: Controller → Service → Repository
- Use constructor injection (via @RequiredArgsConstructor)
- Keep controllers thin - business logic in services
- Use transactions at service layer

## Best Practices

### JPA
- Use `@Transactional` with appropriate transaction manager
- Prefer `findById` over `getById` (avoids lazy loading issues)
- Use batch inserts for bulk operations

### Liquibase
- Always add preconditions for production safety
- Use `onFail="MARK_RAN"` for idempotent migrations
- Separate staging and persistent database changelogs

### Testing
- Use `@SpringBootTest` for integration tests
- Use `@ActiveProfiles("test")` for test configuration
- Prefer AssertJ for assertions

## Common Commands

```bash
# Compile
mvn compile

# Run tests
mvn test

# Run application
mvn spring-boot:run

# Build JAR
mvn clean package
```
