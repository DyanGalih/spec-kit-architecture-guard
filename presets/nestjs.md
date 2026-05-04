# 🦁 NestJS Architecture Adapter

> NestJS-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **NestJS** primitives. It leverages NestJS's opinionated Module system to enforce strict boundary isolation and dependency injection patterns.

---

## Boundary Mapping Summary

| Generic Boundary | NestJS Equivalent |
| --- | --- |
| **Entry** | Controllers (`@Controller()`), Resolvers (`@Resolver()`), Gateways (`@WebSocketGateway()`) |
| **Validation** | Pipes (`@UsePipes(ValidationPipe)`), `class-validator` decorators |
| **Contract** | DTOs (`Data Transfer Objects`), TypeScript Interfaces, GraphQL Schemas |
| **Application** | Services (`@Injectable()`), Command/Query Handlers (CQRS) |
| **Domain** | Entities, Value Objects, Domain Services (agnostic providers) |
| **Data** | TypeORM/Prisma/Mongoose Entities and Repositories |
| **Integration** | Custom Providers (wrappers for external SDKs), Clients |
| **Presentation** | Controllers (for REST), Resolvers (for GraphQL), Microservice Handlers |

---

## Detection Rules & Anti-Patterns

### 1. Module Boundary Leaks
**Rule**: Modules should only communicate through exported Providers.
- **Violation**: Importing a class from another module that is not listed in its `exports` array.
- **Recommendation**: Ensure the provider is exported by its parent module and imported via the `imports` array.

### 2. Fat Controllers
**Rule**: Controllers must only handle request mapping and delegation.
- **Violation**: Business logic, database queries, or complex data transformations inside a `@Get()` or `@Post()` method.
- **Recommendation**: Delegate all business logic to an injected **Service**.

### 3. Bypassing Dependency Injection
**Rule**: Use NestJS DI for all service-to-service communication.
- **Violation**: Using `new ServiceName()` or global singletons instead of injecting the provider via the constructor.
- **Recommendation**: Register the class as a Provider and inject it.

### 4. Missing DTO Enforcement
**Rule**: All external inputs must use a DTO with validation decorators.
- **Violation**: Using `@Body() body: any` or raw interfaces without `class-validator` decorators.
- **Recommendation**: Create a class-based DTO and use `ValidationPipe`.

---

## Focus Areas

### `api` Focus
Targets Controllers, Resolvers, and DTOs. Ensures consistent status codes, versioning, and validation.

### `db` Focus
Targets TypeORM/Prisma entities and Repository patterns.

### `general` Focus
Reviews the full NestJS lifecycle: Guard → Interceptor → Pipe → Controller → Service → Repository.
