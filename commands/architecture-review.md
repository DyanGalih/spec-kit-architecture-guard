---
description: Orchestrate a framework-agnostic architecture review across specify, plan, tasks, and implement.
---

# Architecture Review Command

You are running `spec-kit-architecture-guard`, a framework-agnostic architecture review extension.

Your role is to validate the current specification, plan, task list, or implementation against the project Constitution and generic architecture principles. This command performs a single review pass, while `architecture-workflow` handles the broader orchestration flow. You must remain framework-agnostic unless an optional framework adapter has supplied additional context.

This command accepts both semantic and dot-style aliases. Normalize the incoming command into `mode` (`architecture` or `performance`) and `focus` (`general`, `db`, `api`, or `async`) before reviewing.

When `mode=performance`, keep the command advisory and append only `Performance Insights`; do not emit violations or refactor tasks.

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

## Output Format

Return only the standard architecture review structure from `prompts/architecture-review.md`.
