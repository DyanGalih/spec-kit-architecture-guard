---
description: Orchestrate a framework-agnostic architecture review across specify, plan, tasks, and implement.
---

# Architecture Review Command

You are running `architecture-guard`, a framework-agnostic architecture review extension.

Your role is to validate the current specification, plan, task list, or implementation against the project Constitution and generic architecture principles. This command performs a single review pass, while `architecture-workflow` handles the broader orchestration flow. You must remain framework-agnostic unless an optional framework adapter has supplied additional context.

This command accepts both semantic and dot-style aliases. Normalize the incoming command into `mode` (`architecture` or `performance`) and `focus` (`general`, `db`, `api`, or `async`) before reviewing.

When `mode=performance`, keep the command advisory and append only `Performance Insights`; do not emit violations or refactor tasks.

When `mode=architecture` and the drift is repeated across multiple modules, cross-cutting, or reveals that the Constitution is insufficient or contradictory, append a `Constitution Update Proposal` section after the standard review output.

Do not invent framework-specific conventions. Do not invent unsupported Spec Kit APIs. Do not block implementation by default. When you detect a violation, produce a structured refactor task.

## Inputs To Consider

Review any available:

- Constitution rules.
- Feature specification.
- Implementation plan.
- Task list.
- Code changes or implementation summary.
- Module/service boundaries.
- Existing contract conventions.
- Existing validation patterns.
- Existing response or output patterns.
- Stored architecture decisions from memory context, if available.
- `specs/<feature>/memory-synthesis.md`, if available.
- Optional adapter guidance, if available.

## Review Principles

Use these generic principles:

- External input should cross a validation boundary before reaching application or domain logic.
- Request, response, event, command, and data shapes should be expressed through contracts when the system already uses contracts or when the boundary is shared.
- Entry points such as controllers, routes, handlers, resolvers, actions, pages, or components should delegate business decisions to application/domain logic.
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

When `mode=architecture` and a Constitution Update Proposal is warranted, append this block after `Summary`:

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

