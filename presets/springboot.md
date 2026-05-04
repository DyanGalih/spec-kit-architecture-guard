# 🍃 Spring Boot Architecture Adapter

> Spring Boot-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **Spring Boot** primitives. It enforces the standard **Controller-Service-Repository** pattern and ensures proper usage of the Spring IoC container.

---

## Boundary Mapping Summary

| Generic Boundary | Spring Equivalent |
| --- | --- |
| **Entry** | Controllers (`@RestController`), Message Listeners (`@KafkaListener`), Filters |
| **Validation** | Bean Validation (`@Valid`), custom `Validator` implementations |
| **Contract** | DTOs, Request/Response Records, API Schemas (Swagger/OpenAPI) |
| **Application** | Services (`@Service`), Use Case handlers, Facades |
| **Domain** | Entities (`@Entity`), Value Objects, Domain Services |
| **Data** | Repositories (`@Repository`), Spring Data JPA, QueryDSL |
| **Integration** | Feign Clients, RestTemplate/WebClient, External SDK Beans |
| **Presentation** | JSON/XML Serializers, Thymeleaf Templates (if used) |

---

## Detection Rules & Anti-Patterns

### 1. Business Logic in Controllers
**Rule**: Controllers should be restricted to request/response handling.
- **Violation**: Using `@Autowired` repositories directly in a Controller or performing business calculations in a `@RequestMapping` method.
- **Recommendation**: Inject and delegate to a **Service**.

### 2. Leaking Entities to API
**Rule**: Never expose `@Entity` classes directly through the API.
- **Violation**: Returning an Entity class from a Controller method.
- **Recommendation**: Map the Entity to a **DTO** or **Record** before returning it.

### 3. Missing Transaction Boundaries
**Rule**: Use `@Transactional` at the Service (Application) layer.
- **Violation**: Performing multiple database writes without an explicit transaction boundary or putting `@Transactional` on a Repository.
- **Recommendation**: Place `@Transactional` on the Service method that coordinates the workflow.

### 4. Direct Injection of Implementation
**Rule**: Depend on abstractions.
- **Violation**: Injecting a concrete class instead of an interface when multiple implementations are possible.
- **Recommendation**: Inject the Interface and use `@Qualifier` or `@Primary` if necessary.

---

## Focus Areas

### `api` Focus
Targets Controllers and DTOs. Checks for proper HTTP status codes and API consistency.

### `db` Focus
Targets JPA Entities and Repositories. Checks for N+1 query risks and proper relationship mapping.

### `general` Focus
Reviews the lifecycle: Filter → Controller → Service → Repository → Entity.
