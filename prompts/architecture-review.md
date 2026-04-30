# Architecture Review Prompt

Use this prompt when you need a framework-agnostic architecture review for `spec-kit-architecture-guard`.

## Goal

Validate the current specification, plan, task list, or implementation against the project Constitution and generic architecture principles.

The output should identify architectural drift without inventing framework-specific conventions or blocking delivery by default.

## Command Normalization

Accept both semantic and dot-style command forms.

Normalize all inputs into:

- `mode=architecture` by default
- `mode=performance` when the command includes `performance`
- `focus=general` by default
- `focus=db` when the command includes `db`
- `focus=api` when the command includes `api`
- `focus=async` when the command includes `async`

Map dot-style aliases such as `/architecture-review.performance.db` to the same normalized `mode + focus` model.

If the command context includes `performance`, keep the review advisory and do not emit `Violations` or `Refactor Tasks`.

## Performance Mode

When `mode=performance`:

- do not emit `Violations`
- do not emit `Refactor Tasks`
- append only `Performance Insights`
- keep the output advisory
- do not claim measured runtime evidence
- do not replace profiling or benchmarking

Use `focus=db` for data-access and query shape concerns, `focus=api` for payload and response-shaping concerns, `focus=async` for blocking-versus-background work concerns, and `focus=general` for broad performance guidance.

When `mode=performance`, append only `Performance Insights`.

## Constitution Update Proposals

When the current work indicates a system-level rule change rather than a local refactor, append a `Constitution Update Proposal` section after `Summary`.

Use it when:

- the same drift appears across multiple modules
- the refactor is cross-cutting rather than local
- the current Constitution is insufficient or contradictory
- a new pattern is consistently emerging

Do not use it for single local issues or minor inconsistencies.
Constitution Update Proposals are non-blocking, require explicit approval, and are never auto-applied.

## Inputs

Review any available:

- Constitution rules.
- Feature specification.
- Implementation plan.
- Task list.
- Code changes or implementation summary.
- Module or service boundaries.
- Existing contract conventions.
- Existing validation patterns.
- Existing response or output patterns.
- Stored architecture decisions from memory context, if available.
- `specs/<feature>/memory-synthesis.md`, if available.
- Optional adapter guidance, if available.

## Review Rules

Use these generic principles:

- External input should cross a validation boundary before reaching application or domain logic.
- Request, response, event, command, and data shapes should be expressed through contracts when the system already uses contracts or when the boundary is shared.
- Entry points such as controllers, routes, handlers, resolvers, actions, pages, or components should delegate business decisions to application or domain logic.
- Modules should depend on stable abstractions instead of reaching into another module's internals.
- Data access should be isolated behind a repository, gateway, service, client, query abstraction, or equivalent when the architecture expects abstraction.
- Output structures should remain consistent across comparable endpoints, pages, services, events, or modules.
- Shared behavior should not be duplicated in ways that create inconsistent rules.
- Architecture review should identify drift without converting style preferences into hard failures.
- Security findings should be handed off to Security Review unless the issue is specifically an architectural boundary problem.

## Detection Scope

Detect violations such as:

- Missing or inconsistent data contracts.
- Business logic leaking into controllers, routes, handlers, UI components, or other entry points.
- Tight coupling between modules.
- Direct data access without an expected abstraction.
- Inconsistent response, output, or error structure.
- Missing validation boundaries.
- Separation of concerns violations.
- Contract mismatch between API, UI, service, event, or storage boundaries.
- Similar modules using incompatible patterns without a documented reason.

## Non-Goals

Do not perform:

- Security review, except to note architectural boundary bypasses.
- Performance review.
- Framework-specific linting.
- Formatting review.
- Runtime static analysis.
- Dependency vulnerability analysis.

Route security concerns to `security-review` when applicable.

## Review Procedure

1. Identify the architecture expectations from the Constitution and available context.
2. Identify the implementation boundaries: input, output, application logic, domain logic, data access, integrations, UI state, and shared contracts.
3. Compare current work against nearby or analogous modules.
4. Detect violations using the generic principles above.
5. Assign severity based on architectural risk and Constitution impact.
6. Generate non-blocking refactor tasks for each meaningful violation.
7. Summarize consistency across modules, services, handlers or controllers, and contracts.

## Severity Guide

- `Critical`: Violates a blocking Constitution rule or creates immediate architectural breakage.
- `High`: Creates significant coupling, boundary erosion, or contract inconsistency.
- `Medium`: Introduces local drift that may spread if repeated.
- `Low`: Minor inconsistency or naming or shape drift worth cleaning up later.

## Output Format

Return only this structure:

```text
Architecture Review

Constitution Alignment:
- Status:
- Notes:

Violations:
- Type:
  Severity:
  Location:
  Description:
  Evidence:
  Principle:

Refactor Tasks:
[Refactor Task]
Title:
Reason:
Scope:
Priority:
Suggested Fix:

Consistency Notes:
- Modules:
- Services:
- Handlers/Controllers:
- Data Contracts:

Summary:
- Overall Risk:
- Recommended Next Step:
```

When `mode=performance`, append only this block and omit `Violations` and `Refactor Tasks`:

```text
Performance Insights:
- Suggestion:
- Context:
- Trade-off:
```

When a Constitution Update Proposal is warranted, append this block after `Summary`:

```text
Constitution Update Proposal:

[Proposal]
Title:
Current Rule:
Proposed Change:
Rationale:
Impact Scope:
Migration Strategy:
Risk Level:
Suggested Version Bump:
```

If no violations are found, write:

```text
Violations:
- None detected

Refactor Tasks:
- None
```

## Rules

- Be specific and actionable.
- Prefer architectural evidence over speculation.
- Do not block implementation unless the Constitution explicitly says the violation is blocking.
- If a finding is uncertain, label it as a risk rather than a confirmed violation.
- Keep framework-specific names descriptive, not prescriptive.
- Preserve incremental adoption by suggesting small refactors.
