# Generic Backend Example

## Context

A backend feature adds an order creation endpoint.

Existing architecture expectations:

- Entry boundaries validate and normalize input.
- Application services coordinate workflows.
- Domain logic owns business rules.
- Persistence is accessed through a data abstraction.
- API responses use a consistent result envelope.

## Implementation Snapshot

```text
POST /orders

Handler:
- Reads raw request body.
- Calculates discount eligibility.
- Writes directly to the database.
- Returns `{ id, ok: true }`.

Nearby modules:
- Account and billing modules use request contracts.
- Account and billing modules return `{ data, meta, errors }`.
- Persistence access goes through module repositories.
```

## Architecture Review

```text
Architecture Review

Constitution Alignment:
- Status: Partially aligned
- Notes: The feature follows the expected use case but bypasses validation, contract, business logic, and data access boundaries used by nearby modules.

Violations:
- Type: Missing Data Contract
  Severity: Medium
  Location: Order creation input
  Description: The endpoint accepts raw request data without an explicit request contract.
  Evidence: The handler reads request body fields directly instead of using a DTO, schema, interface, request object, or equivalent.
  Principle: External input should cross a validation and contract boundary before reaching application logic.

- Type: Business Logic In Entry Boundary
  Severity: High
  Location: Order creation handler
  Description: Discount eligibility is calculated inside the endpoint handler.
  Evidence: The request entry point owns a business decision instead of delegating to application or domain logic.
  Principle: Entry boundaries should coordinate validation, mapping, and delegation, not own domain decisions.

- Type: Direct Data Access Without Abstraction
  Severity: High
  Location: Order creation handler
  Description: The handler writes directly to persistence instead of using the module data abstraction.
  Evidence: Nearby modules use repositories, while this handler performs direct database writes.
  Principle: Data access should follow the established abstraction for the module.

- Type: Inconsistent Response Or Output Structure
  Severity: Medium
  Location: Order creation response
  Description: The endpoint returns a custom `{ id, ok: true }` shape instead of the established response envelope.
  Evidence: Comparable modules return `{ data, meta, errors }`.
  Principle: Comparable boundaries should expose consistent output structures.

Refactor Tasks:
[Refactor Task]
Title: Add an order creation request contract
Reason: Raw request data currently enters the order workflow without a stable input shape.
Scope: Order creation input boundary and application service input.
Priority: P2
Suggested Fix: Define an order creation DTO, schema, interface, request object, or equivalent contract, then validate and normalize input before delegation.

[Refactor Task]
Title: Move discount eligibility into order application or domain logic
Reason: The endpoint handler currently owns a business rule, which weakens separation of concerns.
Scope: Order creation handler and order application/domain service.
Priority: P1
Suggested Fix: Extract discount eligibility into an order service, domain policy, or use-case function and keep the handler focused on validation, mapping, and delegation.

[Refactor Task]
Title: Route order persistence through the module data abstraction
Reason: Direct persistence access in the handler bypasses the pattern used by nearby modules.
Scope: Order creation persistence path.
Priority: P1
Suggested Fix: Add or reuse an order repository, gateway, query service, or equivalent abstraction and call it from the application layer.

[Refactor Task]
Title: Align order creation response with the shared result envelope
Reason: The endpoint returns a custom output shape that differs from comparable modules.
Scope: Order creation response mapping.
Priority: P2
Suggested Fix: Return the established `{ data, meta, errors }` structure or document an accepted deviation.

Consistency Notes:
- Modules: Order module currently diverges from account and billing module patterns.
- Services: Application coordination is missing or bypassed.
- Handlers/Controllers: Handler contains validation, business logic, and persistence work.
- Data Contracts: Request and response contracts should be made explicit.

Summary:
- Overall Risk: High
- Recommended Next Step: Continue delivery if needed, but schedule the P1 refactor tasks before adding more order workflows.
```

