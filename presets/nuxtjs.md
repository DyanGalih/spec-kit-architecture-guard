# 🟢 Nuxt.js Architecture Adapter

> Nuxt-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **Nuxt 3** primitives, focusing on Nitro server routes, Composables, and the unique directory-based structure of Nuxt.

---

## Boundary Mapping Summary

| Generic Boundary | Nuxt Equivalent |
| --- | --- |
| **Entry** | Pages, Server Routes (`server/api/`, `server/routes/`), Middleware |
| **Validation** | `readBody` validation, h3 utilities, Zod schemas |
| **Contract** | TypeScript Types, Nitro auto-generated types, Shared DTOs |
| **Application** | Server-side logic, Composables (shared logic), Plugins |
| **Domain** | `utils/` business logic, pure domain classes in `lib/` or `domain/` |
| **Data** | Prisma/Drizzle, Nitro Storage, `$fetch` with interceptors |
| **Integration** | Server routes (proxying), Nitro plugins, external API modules |
| **Presentation** | Vue Components, Layouts, Composables (UI state) |

---

## Detection Rules & Anti-Patterns

### 1. Nitro Route Logic
**Rule**: Server routes (`server/api`) should handle request/response and delegate business logic.
- **Violation**: Massive database queries or complex domain workflows inside an `defineEventHandler`.
- **Recommendation**: Extract logic into a `server/utils` or a dedicated business layer.

### 2. Over-reliance on Global Composables
**Rule**: Composables should be scoped and focused.
- **Violation**: A single "god-composable" that manages everything from auth to complex product math.
- **Recommendation**: Split into specialized composables (e.g., `useCart`, `useAuth`).

### 3. Missing Server Validation
**Rule**: All input to `server/api` must be validated on the server.
- **Violation**: Assuming the frontend has already validated the data and using `readBody()` directly.
- **Recommendation**: Use `zod` or `h3` validation helpers at the start of the event handler.

### 4. Client-only Boundary Leaks
**Rule**: Sensitive logic must remain in Nitro (server).
- **Violation**: Storing secret keys or performing sensitive permission checks inside a frontend Vue component.
- **Recommendation**: Move the sensitive logic to a Nuxt server route.

---

## Focus Areas

### `api` Focus
Targets `server/api` routes and h3 event handlers. Ensures proper error handling and consistent JSON shapes.

### `db` Focus
Targets database integration within Nitro and usage of `useStorage` for server-side persistence.

### `general` Focus
Reviews the flow from Vue Component → Composable → Nitro API → Database.
