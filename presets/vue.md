# 🟢 Vue (Standalone) Architecture Adapter

> Architecture rules for standalone Vue 3 projects not using Nuxt.

## Role in the Suite

This adapter enforces the **Vue 3 Composition API** standards and ensures a clean separation between Template, Script, and Store.

---

## Boundary Mapping Summary

| Generic Boundary | Vue Equivalent |
| --- | --- |
| **Entry** | Page Components, Router Guards, Event Handlers |
| **Validation** | Zod/VeeValidate, custom validation functions |
| **Contract** | TypeScript Interfaces, DTOs, Prop Definitions |
| **Application** | Composables (`useWorkflow`), Pinia Actions |
| **Domain** | Pure JS/TS business logic, utility functions in `src/utils` |
| **Data** | Pinia Stores, Axios/Fetch clients, API Services |
| **Integration** | API wrappers, Plugin configurations |
| **Presentation** | Base Components, Layouts, CSS (Scoped/Tailwind) |

---

## Detection Rules & Anti-Patterns

### 1. Fat script setup
**Rule**: Keep `<script setup>` focused on component-specific reactive state.
- **Violation**: Multi-step domain workflows or raw API calls inside the component script.
- **Recommendation**: Move the logic to a **Composable** or a **Pinia Store**.

### 2. Mutable Props
**Rule**: Props are read-only.
- **Violation**: Directly trying to mutate a prop or assigning a prop to a `ref` and then mutating that `ref` without emitting an event.
- **Recommendation**: Use the `emit` pattern (v-model) to notify the parent of changes.

### 3. Business Logic in Templates
**Rule**: Keep templates declarative.
- **Violation**: Complex ternary operators or function calls with side effects inside `{{ }}`.
- **Recommendation**: Use **Computed Properties**.

### 4. Direct Store Access Overload
**Rule**: Components should only access what they need.
- **Violation**: Mapping the entire store to a component when only one property is used.
- **Recommendation**: Destructure the store or use a getter.

---

## Focus Areas

### `api` Focus
Targets Pinia actions and API service layers.

### `general` Focus
Reviews the flow: Template → Script Setup → Composable → Pinia Store → API.
