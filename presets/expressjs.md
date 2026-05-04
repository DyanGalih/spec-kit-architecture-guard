# 🚂 Express.js Architecture Adapter

> Express-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **Express.js** primitives. Since Express is unopinionated, this adapter enforces a standard **Controller-Service-Repository** pattern unless otherwise specified in your Constitution.

---

## Boundary Mapping Summary

| Generic Boundary | Express Equivalent |
| --- | --- |
| **Entry** | Route Handlers, Controllers, Middlewares |
| **Validation** | `express-validator`, `zod`, `joi`, custom validation middleware |
| **Contract** | TypeScript Interfaces, JSON Schemas, Shared API definitions |
| **Application** | Service classes (`services/`), Use Case handlers |
| **Domain** | Domain Entities, pure business logic functions |
| **Data** | ORM Models (Sequelize, TypeORM, Mongoose), Repository classes |
| **Integration** | Axios/Fetch wrappers, Integration services, Webhook handlers |
| **Presentation** | JSON responses, Template engines (EJS, Pug) |

---

## Detection Rules & Anti-Patterns

### 1. Fat Route Handlers
**Rule**: Route handlers should only parse request parameters and delegate.
- **Violation**: SQL queries, business logic, or complex transformations written inside the `(req, res) => { ... }` block.
- **Recommendation**: Move logic to a **Service** class.

### 2. Middleware Bloat
**Rule**: Middleware should handle cross-cutting concerns (Auth, Logging, Parsing).
- **Violation**: Business decisions or domain validation happening inside a global or route-level middleware.
- **Recommendation**: Keep middleware generic; move business decisions to the Application or Domain layer.

### 3. Missing Error Boundary
**Rule**: Use centralized error handling.
- **Violation**: Scattering `try/catch` blocks in every controller that manually call `res.status(500).send()`.
- **Recommendation**: Use a global error handler middleware and call `next(error)`.

### 4. Direct DB Access in Controllers
**Rule**: Isolate persistence logic.
- **Violation**: Controllers importing Mongoose/Sequelize models and performing complex queries directly.
- **Recommendation**: Use the **Repository** pattern to wrap data access.

---

## Focus Areas

### `api` Focus
Targets routes and controllers. Checks for consistent status codes and response envelopes.

### `db` Focus
Targets model definitions and repository logic.

### `general` Focus
Reviews the full request lifecycle: Middleware → Controller → Service → Repository.
