---
description: Apply React-specific architecture conventions during architecture review.
---

# Architecture Guard — React (Standalone) Architecture Adapter

Use the core architecture review rules first. This adapter refines generic architecture concepts with **React (Standalone/Vite/CRA)** conventions. It specifically focuses on the separation of UI (Components) and Logic (Hooks/Services), preventing the "Fat Component" anti-pattern and enforcing clean state management.

---

## Boundary Mapping

When reviewing a React project, map generic architecture boundaries to React primitives:

### Entry Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Entry point for HTTP routing | Pages (in `src/pages/` or `src/routes/`) |
| Entry point for User Events | Event Handlers in components |
| Global Layout / Context | Layout Components or Context Providers |
| Navigation filtering | Route Guards / Protected Route components |

### Validation Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Form validation | Zod / Yup / Valibot schemas |
| Input transformation | React Hook Form `transform` or manual state mapping |

### Contract Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Component contracts | TypeScript Interfaces (`Props`) |
| API contracts | DTO Interfaces for Request/Response |
| Shared state shapes | Store Interfaces (Zustand, Redux, or Context) |

### Application Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Shared logic coordination | Custom Hooks (`src/hooks/`) |
| Use case orchestration | Logic-heavy Hooks or Service classes |
| Global state coordination | Store Actions (Zustand) or Thunks (Redux) |

### Domain Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Business rules and decisions | Pure JS/TS Functions in `src/domain/` or `src/utils/` |
| Domain entities | TypeScript Types or Classes |

### Data Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Persistence abstraction | API Clients (`src/api/` or `src/services/`) |
| Data fetching layer | React Query (TanStack Query) hooks or SWR |
| Persistence management | LocalStorage / IndexedDB wrappers |

### Presentation Boundary

| Generic Concept | React Equivalent |
| --- | --- |
| Pure UI Components | Presentational / Dumb Components (`src/components/ui/`) |
| Composed UI | Container Components or Page Components |
| Global UI State | Theme Providers, Toast Providers |

---

## React-Specific Detection Rules

### Fat Component (Logic Leakage)

Detect when a component:
- Contains more than 15 lines of business logic (calculations, complex filtering, multi-step workflows).
- Directly uses `fetch` or `axios` inside a `useEffect` (this should be in a Service or Data hook).
- Manually manages complex state that should be in a **Custom Hook** or a **Store**.

**Acceptable in components:**
- UI-only state (`isOpen`, `isHovered`).
- Mapping props to JSX.
- Calling a single custom hook or dispatching a store action.

### The "Smart vs. Dumb" Boundary

Detect when:
- Reusable UI components (`src/components/ui/`) import from the API layer or the Global Store (they should be pure and driven by props).
- Components directly access `localStorage` or `sessionStorage` instead of using an abstraction.

### Prop Drilling vs. Context

Detect when:
- A prop is passed through more than 3 levels of components without being used by the middle layers (Prop Drilling).
- **Recommendation**: Consider using **Context API** or a **Zustand** store.

### Missing Data Fetching Abstraction [Focus: api]

Detect when:
- Raw `fetch` or `axios` calls are written inside component bodies.
- API endpoints are hardcoded in components instead of being in a centralized `api/` or `constants/` file.

---

## Common React Anti-Patterns to Flag

### 1. Fat Component (Mixed Concerns)

```tsx
// ❌ Component handles UI and API logic
export function UserProfile({ id }) {
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetch(`/api/users/${id}`)
      .then(res => res.json())
      .then(data => {
        // complex transformation logic here...
        setUser(data);
      });
  }, [id]);

  if (!user) return <Spinner />;
  return <div>{user.name}</div>;
}
```

```tsx
// ✅ UI Component delegates to Hook
import { useUser } from "@/hooks/useUser";

export function UserProfile({ id }) {
  const { user, isLoading } = useUser(id); // Logic is here

  if (isLoading) return <Spinner />;
  return <div>{user.name}</div>;
}
```

### 2. Leaky UI Components

```tsx
// ❌ Button depends on Global Auth Store
import { useAuthStore } from "@/store/auth";

export function LogoutButton() {
  const logout = useAuthStore(s => s.logout);
  return <button onClick={logout}>Logout</button>;
}
```

---

## Output Format

When this adapter is active, the architecture review should include a **React Conventions** section:

```text
React Conventions:
- Logic Separation: [Hooks-based / Component-heavy / Mixed]
- Component Purity: [Strict / Leaky UI / Fat Containers]
- State Management: [Store-driven / Context / Prop-Drilling]
- Data Fetching: [Abstracted / Raw-Fetch / Mixed]
```

---

## Guardrails

- Do not flag small (1–3 lines) logic in components as violations.
- Do not require a global store for small projects.
- The Constitution is the final authority. This adapter provides React context, not overrides.
