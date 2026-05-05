---
description: Apply Express-specific architecture conventions during architecture review.
---

# Architecture Guard — Express.js Architecture Adapter

Use the core architecture review rules first. This adapter refines generic architecture concepts with **Express.js** conventions. Since Express is unopinionated, this adapter enforces a standard **Controller-Service-Repository** pattern to prevent the common "Spaghetti Route" anti-pattern.

---

## Boundary Mapping

When reviewing an Express project, map generic architecture boundaries to Express primitives:

### Entry Boundary

| Generic Concept | Express Equivalent |
| --- | --- |
| Entry point for HTTP requests | Routes (`router.get`, `router.post`) |
| Request processing | Controllers (`export const getX = (req, res) => { ... }`) |
| Request/Response hooks | Middleware (`app.use`, `router.use`) |
| Global error handling | Error Middleware (`(err, req, res, next) => { ... }`) |

### Validation Boundary

| Generic Concept | Express Equivalent |
| --- | --- |
| Input validation | `express-validator`, `zod`, or `joi` middlewares |
| Schema enforcement | Validation middleware applied at the route level |

### Contract Boundary

| Generic Concept | Express Equivalent |
| --- | --- |
| API contracts | TypeScript Interfaces or JSON Schemas |
| Shared response shapes | Custom response wrappers or classes |

### Application Boundary

| Generic Concept | NestJS Equivalent (Context) |
| --- | --- |
| Shared logic coordination | Services (`src/services/`) |
| Use case orchestration | Service classes or functions |

### Domain Boundary

| Generic Concept | Express Equivalent |
| --- | --- |
| Business rules and decisions | Pure JS/TS Functions in `src/domain/` or `src/models/` |
| Domain entities | TypeScript Interfaces or Classes |

### Data Boundary

| Generic Concept | Express Equivalent |
| --- | --- |
| Persistence abstraction | Repositories (`src/repositories/`) |
| Persistence models | Mongoose Schemas, TypeORM Entities, Sequelize Models |
| Database Migration | Knex Migrations, TypeORM Migrations, etc. |

---

## Express-Specific Detection Rules

### Fat Route Handlers (Anti-Pattern: Spaghetti Routes)

Detect when a route handler (the function passed to `router.get` or `app.post`):
- Directly performs database queries (e.g., `await User.find()`).
- Contains business logic calculations or multi-step domain workflows.
- Directly handles low-level error formatting.

**Acceptable in route handlers (Controllers):**
- Extracting `req.params`, `req.query`, and `req.body`.
- Calling a Service function/method.
- Sending the response with `res.status().json()`.

### Missing Validation Middleware [Focus: api]

Detect when:
- A Controller uses `req.body` directly without a preceding validation middleware.
- Validation logic is written inside the Controller body instead of a separate middleware.

### Global Error Handling Boundary

Detect when:
- Controllers use `try/catch` to manually send `res.status(500)` instead of calling `next(err)`.
- **Recommendation**: Always use a centralized error handling middleware and pass errors via `next()`.

### Middleware Responsibility

Detect when:
- Middleware performs database writes or complex business logic (Middleware should be for cross-cutting concerns: Auth, Logging, Parsing).
- Middleware modifies `req` in a way that is not documented in the shared context.

---

## Common Express Anti-Patterns to Flag

### 1. Spaghetti Route (Mixed Concerns)

```javascript
// ❌ Route handles everything
router.post('/register', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).send('Missing data');
  const user = await User.findOne({ email });
  if (user) return res.status(400).send('Exists');
  const newUser = await User.create({ email, password });
  await sendEmail(email);
  res.status(201).json(newUser);
});
```

```javascript
// ✅ Route delegates to Controller, which delegates to Service
router.post('/register', validateRegister, userController.register);

// controller.js
export const register = async (req, res, next) => {
  try {
    const user = await userService.register(req.body);
    res.status(201).json(user);
  } catch (err) {
    next(err);
  }
};
```

---

## Output Format

When this adapter is active, the architecture review should include an **Express Conventions** section:

```text
Express Conventions:
- Route Logic: [Clean-Controllers / Spaghetti / Mixed]
- Error Handling: [Centralized / Scattered / Manual]
- Logic Isolation: [Service-based / Controller-heavy]
- Validation Pattern: [Middleware-based / Inline / Missing]
```

---

## Guardrails

- Do not flag standard Express practices (using Middlewares, simple routers).
- Do not require a full Class-based architecture unless the Constitution requires it.
- The Constitution is the final authority. This adapter provides Express context, not overrides.
