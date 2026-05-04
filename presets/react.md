# ⚛️ React (Standalone) Architecture Adapter

> Architecture rules for standalone React projects (Vite, CRA, etc.) not using Next.js.

## Role in the Suite

This adapter enforces clean architecture in React applications. It focuses on the separation between UI (Components) and Logic (Hooks/Services), preventing the "Fat Component" anti-pattern.

---

## Boundary Mapping Summary

| Generic Boundary | React Equivalent |
| --- | --- |
| **Entry** | Page Components, Route Handlers, Event Handlers |
| **Validation** | Zod/Yup schemas, Formik/React Hook Form validation |
| **Contract** | TypeScript Interfaces, API DTOs, Prop Types |
| **Application** | Custom Hooks (`useWorkflows`), Context Providers |
| **Domain** | Pure JS/TS business logic, utility functions, Entity types |
| **Data** | React Query/SWR, Redux/Zustand stores, API Service clients |
| **Integration** | Axios/Fetch clients, WebSocket handlers, 3rd party SDKs |
| **Presentation** | Presentational (Dumb) Components, Styled Components, CSS Modules |

---

## Detection Rules & Anti-Patterns

### 1. Fat UI Components
**Rule**: UI components should be concerned with rendering and local UI state.
- **Violation**: Direct `fetch()` calls or complex business math inside a component's body.
- **Recommendation**: Extract the logic into a **Custom Hook** or a **Service**.

### 2. Prop Drilling
**Rule**: Use appropriate state management for shared data.
- **Violation**: Passing the same prop through 5+ layers of components.
- **Recommendation**: Use **Context API** or a store like **Zustand** or **Redux**.

### 3. Missing API Abstraction
**Rule**: Do not use `fetch` or `axios` directly in components.
- **Violation**: `useEffect(() => { fetch(...) })` scattered across components.
- **Recommendation**: Create a centralized **API Client** or use **React Query** hooks.

### 4. Logic in Render
**Rule**: Keep the JSX clean.
- **Violation**: Complex `.filter().map()` chains with nested logic inside the return statement.
- **Recommendation**: Compute the data before the `return` or extract it into a memoized variable.

---

## Focus Areas

### `api` Focus
Targets API clients and data hooks. Checks for proper error handling and loading states.

### `general` Focus
Reviews the component hierarchy and the separation between "Smart" (Container) and "Dumb" (Presentational) components.
