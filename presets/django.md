# 🎸 Django Architecture Adapter

> Django-specific architectural rules and boundary mappings for Architecture Guard.

## Role in the Suite

This adapter translates generic architecture principles into **Django (MVT)** primitives. It helps teams resolve the "Fat Model" vs. "Service Layer" debate and ensures that business logic doesn't leak into Views or Templates.

---

## Boundary Mapping Summary

| Generic Boundary | Django Equivalent |
| --- | --- |
| **Entry** | Views (`views.py`), URL configurations, Management Commands, Middleware |
| **Validation** | Forms (`forms.py`), ModelForms, Serializers (for DRF) |
| **Contract** | Forms, DRF Serializers, Pydantic models (if used), TypedDicts |
| **Application** | Service layer (`services.py`), Selectors (`selectors.py`), Signal Handlers |
| **Domain** | Models (`models.py`), Managers, business logic in pure Python modules |
| **Data** | Django ORM, Managers, QuerySets, Migrations |
| **Integration** | HTTP Clients, Task queues (Celery), external SDK wrappers |
| **Presentation** | Templates (`.html`), DRF Serializers (output), Context Processors |

---

## Detection Rules & Anti-Patterns

### 1. Fat Views
**Rule**: Views should only handle request parsing, authentication, and delegation.
- **Violation**: Multi-step business workflows or complex ORM queries written directly inside a view function or Class-Based View (CBV).
- **Recommendation**: Delegate logic to a **Service** function.

### 2. Overloaded Models (Fat Models)
**Rule**: Models should own data integrity and simple state; complex workflows belong elsewhere.
- **Violation**: Model methods that perform external API calls, send emails, or coordinate multi-model transactions.
- **Recommendation**: Move "orchestration" logic to the **Application (Service)** layer.

### 3. Business Logic in Templates
**Rule**: Templates must only handle presentation.
- **Violation**: Using complex logic or calculations inside template tags (`{% if ... %}`).
- **Recommendation**: Calculate the value in the View or a Model property and pass it to the context.

### 4. Direct ORM Usage in Views
**Rule**: Encapsulate complex queries.
- **Violation**: Complex `.filter().exclude().annotate()` chains written inside a view.
- **Recommendation**: Use a **Selector** function or a custom **Manager** method.

---

## Focus Areas

### `api` Focus
Targets Django Rest Framework (DRF) Serializers and API Views. Ensures consistent error responses and field naming.

### `db` Focus
Targets Models, Managers, and Migrations. Checks for missing indexes or dangerous `on_delete` settings.

### `general` Focus
Reviews the flow: View → Service → Selector → Model.
