---
description: This skill should be used when implementing Spring Boot backend features, creating REST endpoints, writing services, repositories, entities, DTOs, or MapStruct mappers. Trigger phrases include "implement endpoint", "create controller", "add service", "write repository", "create entity", "add DTO", "MapStruct mapper", "Spring Boot", "JPA", "Liquibase migration".
---

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
- DTOs: `*DTO` or `*Request`/`*Response` suffix
- Repositories: `*Repository` suffix
- Services: `*Service` suffix

### Comments
- Write all comments in English
- Only add comments where logic is not self-evident
- Use Javadoc for public methods

### Architecture (Layered)

Follow **layered architecture** with clear separation of concerns:

```
com.company.project/
├── config/                     # Spring configuration classes
│   ├── DatabaseConfig          # DataSource, EntityManager, TransactionManager
│   └── WebConfig               # CORS, security settings
│
├── controller/                 # REST API endpoints (Presentation Layer)
│   └── *Controller.java        # Thin controllers, only request handling
│
├── service/                    # Business logic (Service Layer)
│   └── *Service.java           # Transactions, orchestration, business rules
│
├── repository/                 # Data access (Persistence Layer)
│   ├── *Repository.java        # Spring Data JPA interfaces
│   └── specification/          # JPA Specifications for dynamic queries
│
├── domain/                     # Domain model (Entity Layer)
│   ├── *Entity.java            # JPA entities
│   └── internal/               # Internal value objects (not persisted)
│
├── dto/                        # Data Transfer Objects (API contracts)
│   └── *DTO.java               # Request/Response objects for API
│
├── mapper/                     # Entity-DTO transformations
│   └── *Mapper.java            # MapStruct interfaces/abstract classes
│
├── exception/                  # Custom exceptions and handlers
│   └── GlobalExceptionHandler  # @ControllerAdvice for error handling
│
└── util/                       # Utility classes
```

**Multi-Database Setup:** When using multiple databases (e.g., persistent + staging), create sub-packages:
- `domain/persistent/`, `domain/staging/`
- `repository/persistent/`, `repository/staging/`

**Important Design Decisions:**

- **DTOs are NOT in domain**: DTOs represent API contracts, not domain objects
- **Mappers are NOT in domain**: Mappers are infrastructure for transformations
- **Specifications in repository**: Query specifications belong to the persistence layer
- **Controllers only use Services**: Never inject repositories into controllers

**Layer Rules:**

| Layer | Can Use | Cannot Use |
|-------|---------|------------|
| Controller | Service, DTO, Mapper | Repository, Entity directly |
| Service | Repository, Entity, other Services | Controller |
| Repository | Entity, Specification | Service, Controller |
| Mapper | Entity, DTO | Repository, Service |

**General Principles:**

- Use constructor injection (via @RequiredArgsConstructor)
- Keep controllers thin - business logic in services
- Use transactions at service layer with explicit transaction manager

## Best Practices

### JPA
- Use `@Transactional` with appropriate transaction manager
- Prefer `findById` over `getById` (avoids lazy loading issues)
- Use batch inserts for bulk operations
- Use `@EntityGraph` or `JOIN FETCH` to avoid N+1 queries
- Use JPA Specifications for dynamic filtering

### MapStruct

**Interface vs Abstract Class - choose based on use case:**

- **Interface (with `@Context`)**: For batch operations (lists) - avoids N+1 queries
  ```java
  List<ShipmentDTO> toDTOList(List<ShipmentEntity> entities,
                              @Context Map<Integer, Double> dilutionSums);
  ```

- **Abstract Class (with `@Autowired`)**: For single object mapping when additional data needs to be loaded
  ```java
  @Mapper(componentModel = "spring")
  public abstract class OrderMapper {
      @Autowired
      protected CustomerRepository customerRepository;

      @AfterMapping
      protected void enrichOrder(@MappingTarget OrderDTO dto, OrderEntity entity) {
          Customer customer = customerRepository.findById(entity.getCustomerId());
          dto.setCustomerName(customer.getName());
      }
  }
  ```

**When to use which approach:**
- Mapping a list of objects → Interface + `@Context` (batch-load data in service)
- Mapping a single object → Abstract Class + `@Autowired` (load data in `@AfterMapping`)

### Liquibase
- Always add preconditions for production safety
- Use `onFail="MARK_RAN"` for idempotent migrations
- Separate changelogs per database if using multi-database setup

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