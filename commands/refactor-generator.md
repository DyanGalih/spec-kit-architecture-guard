---
description: Convert architecture violations into non-blocking, structured refactor tasks.
---

# Refactor Generator Command

You are generating non-blocking refactor tasks for `architecture-guard`.

Convert architecture violations into structured tasks that preserve delivery momentum while making architectural debt visible and actionable.

Use the same normalized command context as the review workflow. When `mode=performance`, do not invent refactor tasks from performance guidance; that mode is advisory and belongs to `architecture-review` output only.

## Command Normalization

Accept the same normalized command context as the review workflow:

- `mode=architecture` by default
- `mode=performance` when the command includes `performance`
- `focus=general` by default
- `focus=db` when the command includes `db`
- `focus=api` when the command includes `api`
- `focus=async` when the command includes `async`

If `mode=performance`, do not create refactor tasks from performance guidance. That mode is advisory and belongs to `architecture-review` output only.

If the input points to a Constitution Update Proposal, do not convert it into a normal refactor task. Leave it for `architecture-review` and `architecture-apply`.

## Inputs

Use any available:

- Detected violations.
- Constitution rules.
- Feature specification.
- Implementation plan.
- Task list.
- Existing architecture decisions.
- Existing module patterns.
- Optional framework adapter guidance.

## Refactor Task Rules

Each task must:

- Be non-blocking unless the Constitution explicitly says otherwise.
- Have a clear title.
- Explain the architectural reason.
- Define a concrete scope.
- Assign a priority.
- Suggest a small, practical fix.
- Avoid framework-specific requirements unless adapter guidance is present.
- Avoid security or performance remediation unless it is strictly architectural.
- Do not duplicate `Performance Insights` into refactor tasks.

## Priority Guide

- `P0`: Must resolve before release because the Constitution makes it blocking.
- `P1`: Should resolve soon to prevent architectural spread.
- `P2`: Safe to schedule as technical debt.
- `P3`: Opportunistic cleanup.

## Scope Guide

Good scopes:

- One module.
- One request or response boundary.
- One API and its UI consumer.
- One service and its data access path.
- One repeated contract shape.
- One integration boundary.

Avoid scopes that are too broad:

- Refactor the whole backend.
- Clean up all components.
- Rewrite service architecture.
- Make everything consistent.

## Suggested Fix Guide

Suggested fixes should be concrete:

- Introduce or align a DTO, schema, interface, request object, response object, event contract, command object, or equivalent.
- Move business rules from the entry boundary into application or domain logic.
- Add a module-facing abstraction instead of reaching into internals.
- Route persistence access through an established data abstraction.
- Normalize output shape to match nearby modules.
- Add validation at the external input boundary.
- Document an accepted deviation if the current design is intentional.

## Output Format

Return only:

```text
Refactor Tasks:
[Refactor Task]
Title:
Reason:
Scope:
Priority:
Suggested Fix:
```

If no tasks are needed:

```text
Refactor Tasks:
- None
```

Constitution Update Proposals are not refactor tasks.

## Example

```text
Refactor Tasks:
[Refactor Task]
Title: Move pricing rule out of checkout route
Reason: The route currently owns a business decision that should live behind the checkout application boundary.
Scope: Checkout request handler and checkout application service.
Priority: P1
Suggested Fix: Extract pricing decision logic into the checkout service or domain policy, keep the route responsible for validation, mapping, and delegation only.
```
