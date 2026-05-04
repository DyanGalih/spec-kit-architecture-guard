# ⚛️ Next.js Architecture Adapter

> Next.js-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **Next.js (App Router)** primitives. It ensures that Architecture Guard understands the distinction between Server and Client boundaries, and the specific role of Server Actions and Route Handlers.

---

## Boundary Mapping Summary

| Generic Boundary | Next.js Equivalent |
| --- | --- |
| **Entry** | Pages (`page.tsx`), Layouts, Server Actions, Route Handlers (`route.ts`) |
| **Validation** | Zod schemas, `useActionState` validation, manual `parsedBody` checks |
| **Contract** | TypeScript Interfaces/Types, Zod Schemas, Shared API types |
| **Application** | Server Actions (as use-case coordinators), Service classes, helper utils |
| **Domain** | Pure business logic, Entity classes, shared domain constants |
| **Data** | Prisma/Drizzle models, `fetch` with Next.js cache, Server-only data access |
| **Integration** | Route Handlers (webhooks), external fetch calls, 3rd party SDKs |
| **Presentation** | React Server Components (RSC), Client Components (`'use client'`) |

---

## Detection Rules & Anti-Patterns

### 1. Server Action Responsibility
**Rule**: Server Actions should be thin coordinators.
- **Violation**: Large business workflows, complex calculations, or direct third-party SDK orchestration inside a `'use server'` function.
- **Recommendation**: Delegate to a Service or Domain function.

### 2. Leaky Client Components
**Rule**: Business logic and sensitive data fetching must stay on the server.
- **Violation**: `fetch()` calls to internal databases or complex business decisions inside `'use client'` components.
- **Recommendation**: Move data fetching to a parent Server Component and pass only necessary props.

### 3. Missing Validation Boundary
**Rule**: All Server Action and Route Handler inputs must be validated.
- **Violation**: Directly using `formData.get()` or `request.json()` without a schema (e.g., Zod).
- **Recommendation**: Use a Zod schema to parse and validate input at the very beginning of the entry point.

### 4. Direct Data Access in Components
**Rule**: Isolate data fetching logic.
- **Violation**: Complex Prisma/SQL queries written directly inside a UI Component's body.
- **Recommendation**: Extract queries into a dedicated `data/` or `lib/` layer to allow for reuse and easier testing.

---

## Focus Areas

### `api` Focus
Targets Route Handlers, Server Actions, and Zod schemas. Ensures that API responses are consistent and status codes are appropriate.

### `db` Focus
Targets Prisma/Drizzle/Kysely usage and Next.js caching strategies (`revalidatePath`, `unstable_cache`).

### `general` Focus
Full cross-boundary review (e.g., RSC → Server Action → Service → Database).
