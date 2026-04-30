# Violation Detection Prompt

Use this prompt during `plan`, `tasks`, and `implement` workflows to detect framework-agnostic architecture drift for `spec-kit-architecture-guard`.

## Goal

Answer one question: does the current work preserve the architecture described by the Constitution, the specification, existing module patterns, and documented decisions?

## Command Normalization

Accept the same normalized command context as the review workflow:

- `mode=architecture` by default
- `mode=performance` when the command includes `performance`
- `focus=general` by default
- `focus=db` when the command includes `db`
- `focus=api` when the command includes `api`
- `focus=async` when the command includes `async`

If `mode=performance`, do not emit violations here. Let `architecture-review` own the advisory performance output.

When the drift is repeated across multiple modules, cross-cutting, or indicates the Constitution may be insufficient or contradictory, surface that as proposal-worthy input for `architecture-review` and `architecture-apply`.

## Generic Architecture Model

Use this model regardless of framework:

- Entry boundary: receives input from users, clients, jobs, events, CLI commands, routes, controllers, handlers, pages, or components.
- Validation boundary: validates and normalizes external input.
- Contract boundary: defines stable request, response, event, command, DTO, schema, interface, or shared type shapes.
- Application boundary: coordinates use cases and workflows.
- Domain boundary: owns business rules and decisions.
- Data boundary: reads and writes persistence through an approved abstraction.
- Integration boundary: communicates with external systems.
- Presentation boundary: renders UI, formats output, or maps view state.

## Violation Categories

### Missing Data Contract

Detect when:

- Shared or external input lacks a DTO, schema, interface, type, request object, command object, or equivalent.
- Output shape is implied by inline literals only.
- UI and API use different names or shapes for the same concept.
- Events or messages are not documented as contracts.

Do not require contracts for trivial private helper functions unless the Constitution requires it.

### Inconsistent Data Contract

Detect when:

- Similar modules expose different field names for the same concept.
- Response structures differ without a documented reason.
- Validation schema and implementation shape disagree.
- Frontend assumptions do not match backend outputs.
- API, event, or service contracts drift between producer and consumer.

### Business Logic In Entry Boundary

Detect when:

- Controllers, routes, handlers, actions, resolvers, pages, or UI components make core business decisions.
- Entry points perform multi-step domain workflows instead of delegating.
- Validation, orchestration, persistence, and business rules are mixed in one boundary function.

Mapping, authentication context extraction, simple validation calls, and delegation are acceptable.

### Tight Module Coupling

Detect when:

- One module imports another module's internal implementation.
- Services bypass public APIs or contracts.
- A feature reaches into another feature's persistence models, private helpers, or internal state.
- Shared utilities become hidden coordination layers for business behavior.

### Direct Data Access Without Abstraction

Detect when:

- Business logic, UI logic, or entry points query persistence directly despite an established data abstraction.
- Multiple layers construct raw queries or persistence payloads inconsistently.
- External API calls bypass a shared client or gateway expected by the architecture.

Do not flag direct data access if the Constitution explicitly allows active-record-style or direct query patterns for that layer.

### Inconsistent Response Or Output Structure

Detect when:

- Comparable endpoints, handlers, pages, events, or services return incompatible success, error, or result shapes.
- Error handling or result wrapping differs without a documented reason.
- Pagination, metadata, status fields, or envelope conventions drift.

### Missing Validation Boundary

Detect when:

- External input reaches application or domain logic without validation or normalization.
- Validation is duplicated inconsistently across entry points.
- Validation happens after side effects.
- Consumer-side assumptions replace producer-side validation.

### Separation Of Concerns Violation

Detect when:

- UI presentation owns domain rules.
- Persistence models own workflow orchestration.
- Integration clients contain product decisions.
- Shared types contain behavior that belongs in a module.
- Domain logic depends on transport, UI, framework, or database concerns without an accepted reason.

## Severity Assignment

Use:

- `Critical` when a Constitution rule makes the violation blocking.
- `High` when the issue crosses module or service boundaries or will be hard to unwind.
- `Medium` when the issue is local but repeatable.
- `Low` when the issue is minor drift.

## Output Format

Return only:

```text
Violations:
- Type:
  Severity:
  Location:
  Description:
  Evidence:
  Principle:
```

If there are no violations:

```text
Violations:
- None detected
```

## Guardrails

- Do not infer framework rules that were not provided.
- Do not report security, performance, or formatting issues as architecture violations.
- Do not block delivery by default.
- Prefer "risk" language when the evidence is incomplete.
- Keep findings small enough to become refactor tasks.
- Do not duplicate `Performance Insights` from `architecture-review`.
- If the same drift appears across multiple modules, flag it as potential proposal-worthy input rather than forcing only local findings.
