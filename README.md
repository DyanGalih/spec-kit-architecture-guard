# 🛡️ spec-kit-architecture-guard

[![Version](https://img.shields.io/badge/version-1.0.5-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Prompt-based](https://img.shields.io/badge/mode-prompt--based-f59e0b)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Optional adapters](https://img.shields.io/badge/adapters-optional-8b5cf6)](adapters/README.md)

A framework-agnostic Spec Kit extension for lightweight architecture review during AI-assisted delivery.

It helps teams validate implementation work against the project Constitution, detect architectural drift across modules and services, and produce structured, non-blocking refactor tasks when violations appear.

Version `1.0.5` is the current release recorded in `extension.yml`.

Architecture enforcement matters because systems usually degrade through small inconsistencies: one route bypasses a service boundary, one UI module invents a different response shape, one service talks directly to another module's persistence layer, and soon the codebase becomes harder to reason about than the original specification.

This extension is intentionally prompt-based and AI-first. It does not require runtime tools, static analyzers, language servers, framework CLIs, or framework-specific APIs.

## Current Scope

The current release is intentionally simple:

- Repo-first.
- Command-driven.
- Prompt-based.
- Git-reviewable.
- Framework-agnostic at the core.
- Non-blocking by default.

It is not trying to be a runtime analyzer, linter, or framework plugin system.

The extension ships its installable command files in `commands/` and its human-readable source prompts in `prompts/`.

## Extension Manifest

`extension.yml` is the manifest file used by Spec Kit extension ZIP installs for this package:

- `schema_version`
- `extension.id`
- `extension.name`
- `extension.version`
- `extension.description`
- `extension.author`
- `extension.repository`
- `extension.license`
- `requires.speckit_version`
- `provides.commands`
- `tags`

This is the only manifest file users need for installation. The release ZIP should include `extension.yml` at the repository root.

## What This Adds To Spec Kit

Spec Kit already provides structured delivery through `specify`, `plan`, `tasks`, and `implement`, plus project guidance through the Constitution.

This extension adds:

- Architecture review against the Constitution.
- Boundary and contract drift detection across modules and services.
- Structured refactor task generation when violations appear.
- A write-capable apply command for approved plan and task updates.

## Core Idea

- Spec Kit tells you what to build.
- Architecture review tells you whether the shape of that work still fits the system.

The extension keeps architecture guidance in Markdown and command prompts so the team can review, edit, and version it like code.

## At a Glance

If you are new to this extension, this is the shortest accurate mental model:

- `specify` checks boundaries, contracts, ownership, and Constitution expectations.
- `plan` detects coupling, missing abstractions, and contract drift before tasks harden.
- `tasks` turns violations into scoped refactor work.
- `implement` re-checks implementation output against the Constitution and nearby patterns.
- `architecture-apply` writes approved architecture changes into planning artifacts.
- `architecture-workflow` runs the whole architecture pass in one go and folds in optional companion context when available.

In one sentence:

> Spec Kit drives delivery, and `spec-kit-architecture-guard` keeps the architecture honest while delivery moves forward.

## Best Workflow

If you want the shortest path for day-to-day use, start with the orchestration command:

1. Run `architecture-workflow`.
2. Let it read any available Memory Hub context first.
3. Let it review architecture boundaries, contracts, and drift next.
4. Let it flag security-adjacent findings for Security Review.
5. Let it use `architecture-apply` only when plan or task updates should be written back.

Example flow:

```text
/speckit.spec-kit-architecture-guard.architecture-workflow
  -> read Memory Hub context if installed
  -> review spec, plan, tasks, or implementation
  -> route security-adjacent findings to Security Review
  -> apply approved plan/task updates when requested
```

## Command Usage

Use the semantic form first. It is the primary and most readable interface.

### Recommended (Semantic)

```text
/architecture-review
/architecture-review performance
/architecture-review performance db
```

### Alternative (Dot-style)

```text
/architecture-review.performance
/architecture-review.performance.db
```

Normalize both styles into the same internal model:

- `mode=architecture` by default
- `mode=performance` when `performance` is present
- `focus=general` by default
- `focus=db` when `db` is present
- `focus=api` when `api` is present
- `focus=async` when `async` is present

Dot-style aliases map to the same normalized `mode + focus` model.

## Performance Mode (Optional)

Performance mode is advisory.

Use it when you want architecture guidance that highlights likely performance trade-offs without turning the command into a benchmarking tool.

Use it for:

- data-access hot paths
- API payload shaping
- async versus blocking work placement

Do not use it as a substitute for profiling, benchmarking, or runtime metrics.

Architecture mode is strict. Performance mode is advisory.

## Constitution Update Proposals

When `mode=architecture` shows that the current Constitution is too narrow, contradictory, or repeatedly forcing cross-cutting refactors, it can surface a Constitution Update Proposal.

Use this when:

- the same drift appears across multiple modules
- the refactor is cross-cutting rather than local
- the current Constitution is insufficient or contradictory
- a new pattern is consistently emerging

Do not use it for:

- single local issues
- minor inconsistencies

Constitution Update Proposals are non-blocking, require explicit approval, and are never auto-applied. Approved proposals can be carried forward with `architecture-apply`.

## Commands

This extension ships five commands:

- `speckit.spec-kit-architecture-guard.architecture-workflow`: one pass that can also consider Memory Hub context and Security Review handoff.
- `speckit.spec-kit-architecture-guard.architecture-review`: direct architecture review for the current spec, plan, task list, or implementation.
- `speckit.spec-kit-architecture-guard.violation-detection`: focused drift detection during planning, tasks, or implementation review.
- `speckit.spec-kit-architecture-guard.refactor-generator`: turn violations into small, non-blocking refactor tasks.
- `speckit.spec-kit-architecture-guard.architecture-apply`: write approved architecture feedback back into plan or task artifacts.

If you are unsure which command to use, start with `speckit.spec-kit-architecture-guard.architecture-workflow`.

It is the least surprising entry point because it reads optional Memory Hub context, reviews architecture, and tells you whether Security Review should handle any part of the result.

## Installation

Run installation from a Spec Kit project directory, not from this repository.

Choose the source that matches how you want to consume the extension:

### Published Extension

Use this path when the extension has been published to your Spec Kit catalog or extension registry.

```text
cd /path/to/spec-kit-project
specify extension add spec-kit-architecture-guard
```

Use the extension slug registered in your catalog if it differs from the package name above.

### Direct From GitHub

Use this path when you want to install from the GitHub repository, release artifact, or source bundle.

```text
cd /path/to/spec-kit-project
specify extension add spec-kit-architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.0.5.zip
```

Replace the tag with the release you want to pin. If your installer uses a different GitHub source flag, keep the same idea and point it at the release archive.

### Local Development

Use this path when you are developing or editing the extension locally.

```text
cd /path/to/spec-kit-project
specify extension add --dev /path/to/spec-kit-architecture-guard
```

Keep the repository checked out on disk while you are editing it. Re-run the dev install if your Spec Kit setup does not support live linking.

The extension ships its command prompts in `commands/` and its source prompt content in `prompts/`. Spec Kit uses the command files during the workflow, while the prompt files keep the underlying guidance easy to inspect and extend.

After installation, confirm that the command files are available in your Spec Kit project and that the extension is listed by your installer or catalog.

## When To Use This

Use this extension when you want to reduce architecture drift caused by:

- Inconsistent architecture across teams.
- AI-generated code that follows local context but misses system-wide conventions.
- Growing technical debt from repeated small boundary violations.
- Modules and services that evolve with different data contracts.
- Controllers, handlers, components, or routes accumulating business logic.
- Direct data access spreading into layers that should depend on abstractions.

This extension is a strong fit for:

- Multi-module systems.
- Modular monoliths.
- Microservices.
- Full-stack applications with shared contracts.
- AI-assisted development workflows.
- Systems that are scaling beyond one team.
- Products with an evolving architecture or Constitution.
- Codebases where consistency is more valuable than framework-specific purity.

## When Not To Use It

This extension is probably unnecessary for:

- Small scripts.
- Short-lived prototypes.
- Throwaway experiments.
- One-off migrations where architecture consistency is not a goal.
- Repositories where no meaningful module, boundary, or contract structure exists yet.

## Companion Extensions

This extension is designed to cooperate with the companion extensions you own, without duplicating their responsibilities.

The intended split is:

- `spec-kit-memory-hub` provides repository-native memory, active feature synthesis, and durable project context.
- `spec-kit-security-review` owns security findings such as authorization, secrets, injection, and authentication.
- `spec-kit-architecture-guard` owns architecture drift, contract consistency, boundaries, and refactor task generation.

### Security Review

If `spec-kit-security-review` is installed, use it as the dedicated place for authorization, secrets, injection, authentication, and other security findings.

`spec-kit-architecture-guard` should only mention security when a security issue is also an architectural boundary problem, such as bypassing a shared access layer. Otherwise, route the finding to Security Review instead of duplicating it.

### Memory Hub

If `spec-kit-memory-hub` is installed, use it as optional project context for architecture decisions, module boundaries, contract conventions, and accepted deviations.

It should inform the architecture workflow, but it should not be required for the core extension to function. In this extension's workflow, Memory Hub is read context, not a write target.

### One-Command Workflow

When both companion extensions are present, `architecture-workflow` is the recommended single entry point.
When both companion extensions are present, `speckit.spec-kit-architecture-guard.architecture-workflow` is the recommended single entry point.

It runs in serial order:

1. Read Memory Hub context and `specs/<feature>/memory-synthesis.md` if they are available.
2. Run the architecture review against the Constitution, memory synthesis, and nearby patterns.
3. Route security-first findings to Security Review.
4. Emit architecture refactor tasks or an apply recommendation.

Only one workflow should write a given follow-up item:

- `spec-kit-architecture-guard` writes architecture findings into architecture tasks or plan updates.
- `spec-kit-security-review` writes security findings into security follow-up or backlog items.
- `spec-kit-memory-hub` writes durable memory and synthesis updates.

This keeps Memory Hub, Security Review, and `spec-kit-architecture-guard` aligned without duplicating ownership.

### Beginner Tip

If you are unsure which command to use, start with `architecture-workflow`.
If you are unsure which command to use, start with `speckit.spec-kit-architecture-guard.architecture-workflow`.

It reads optional Memory Hub context, reviews architecture, and tells you whether Security Review should handle any part of the result.

## Framework-Agnostic Philosophy

The core extension does not assume Laravel, NestJS, Express, Django, Next.js, React, Vue, or any other framework.

Instead, it reviews generic architectural concepts:

- Contracts: DTOs, schemas, request objects, response objects, interfaces, shared types, message contracts, API contracts.
- Boundaries: controllers, routes, handlers, components, services, domain logic, data access, external integrations.
- Layering: presentation, application, domain, infrastructure, persistence, integration, shared libraries.
- Coupling: module-to-module dependencies, direct persistence access, cross-service shortcuts, hidden shared state.
- Consistency: repeated patterns for validation, output structures, error responses, state ownership, and module organization.

The extension treats framework names as implementation details. A controller may be a route handler, endpoint function, page action, resolver, command handler, or any boundary that accepts outside input and delegates work.

## Core Responsibilities

### Architecture Validation

The extension reviews implementation against the Constitution and detects generic violations such as:

- Missing or inconsistent data contracts.
- Business logic leaking into controllers, routes, handlers, or UI entry points.
- Tight coupling between modules or services.
- Direct data access without an abstraction where the architecture expects one.
- Inconsistent response, output, or error structures.
- Missing validation boundaries.
- Violation of separation of concerns.
- Divergent patterns across similar modules.

### Refactor Suggestion

Violations do not block implementation by default. Instead, the extension emits structured refactor tasks:

```text
[Refactor Task]
Title:
Reason:
Scope:
Priority:
Suggested Fix:
```

This keeps delivery moving while making architectural debt visible, scoped, and actionable.

### Architecture Apply

If you want the extension to update planning artifacts directly, use the write-capable architecture-apply command.

That command can revise:

- `plan.md`
- `tasks.md`
- Related workflow artifacts

It keeps the same architecture principles, but it changes the output from "suggest only" to "apply approved updates."

### Consistency Enforcement

The extension checks consistency across:

- Modules.
- Services.
- Handlers, routes, controllers, resolvers, pages, or components.
- Data contracts such as DTOs, schemas, interfaces, request objects, response objects, and shared types.

### Lightweight Review

This is not a static analysis tool. It is optimized for fast, iterative AI review during Spec Kit workflows.

## Workflow

Use this extension as part of the normal Spec Kit lifecycle:

1. During `specify`, review boundaries, contracts, and Constitution rules.
2. During `plan`, detect coupling, contract drift, and validation gaps before design hardens.
3. During `tasks`, convert architecture findings into scoped refactor tasks.
4. During `implement`, re-check implementation against the architecture you planned.
5. When the team approves an update, use `architecture-apply` to write the plan or task change directly.
6. When you want a single pass that also considers Memory Hub and Security Review, use `architecture-workflow` first.

## Adapter System

Framework adapters are optional companion extensions that refine the core review with framework-specific knowledge.

Examples:

- `spec-kit-architecture-guard-laravel`
- `spec-kit-architecture-guard-nestjs`
- `spec-kit-architecture-guard-nextjs`

Adapters may:

- Add framework-specific vocabulary.
- Add framework-specific examples.
- Refine detection logic.
- Extend prompts with conventions for a known stack.
- Map generic architectural concepts to framework primitives.

Adapters must not:

- Duplicate the core architecture review logic.
- Replace the Constitution as the source of truth.
- Make the core extension framework-specific.
- Convert this extension into a linter or static analyzer.

Create an adapter when a rule depends on a framework convention. Keep a rule in the core extension when it applies across stacks.

Example:

- Core rule: Business logic should not live in request entry points.
- Adapter refinement: In NestJS, controllers should delegate to providers or application services.

## Integration Guide

`spec-kit-architecture-guard` integrates with the following Spec Kit phases:

- `specify`: Capture architectural constraints, contracts, boundaries, module responsibilities, and Constitution expectations.
- `plan`: Review the implementation plan for boundary violations, missing contracts, or coupling risks before tasks are generated.
- `tasks`: Convert risks and violations into structured, non-blocking refactor tasks.
- `implement`: Review implementation output and suggest follow-up refactors without blocking normal delivery.

## Where It Runs In The Flow

Use the commands like this:

| Spec Kit phase | Command | Purpose |
| --- | --- | --- |
| `specify` | `architecture-review` | Check the spec for missing boundaries, contracts, ownership, and consistency assumptions. |
| `plan` | `violation-detection` | Detect architectural risks before the implementation plan is finalized. |
| `tasks` | `refactor-generator` | Convert violations into structured refactor tasks. |
| `tasks` or `implement` | `architecture-apply` | Apply approved architectural improvements directly to `plan.md` or `tasks.md`. |
| `implement` | `architecture-review` | Re-check implementation output against the Constitution and nearby patterns. |

Use `architecture-apply` only when you want the extension to write plan or task updates instead of only reporting them.

## Project Structure

The extension repository is organized like this:

```text
spec-kit-architecture-guard/
├── README.md
├── extension.yml
├── commands/
│   ├── architecture-apply.md
│   ├── architecture-review.md
│   ├── refactor-generator.md
│   └── violation-detection.md
├── prompts/
│   ├── architecture-apply.md
│   ├── architecture-review.md
│   ├── refactor-generator.md
│   └── violation-detection.md
├── adapters/
│   └── README.md
└── examples/
    ├── generic-backend.md
    ├── generic-frontend.md
    └── mixed-architecture.md
```

## Spec Kit Compatibility

This extension follows the current Spec Kit extension manifest shape shown in the extension proposal: `extension.yml` includes `schema_version`, `extension`, `requires`, `provides`, and `tags`.

Installable command prompts live in `commands/`, which keeps the extension compatible with Spec Kit's command-based extension flow. The `prompts/` directory remains as a human-readable source layer for the prompt content.

It does not depend on unsupported Spec Kit APIs, runtime hooks, custom analyzers, or framework plugins.

## Output Format Extension

Architecture reviews still return the standard sections. When relevant, they may also append:

- `Performance Insights` for `mode=performance`
- `Constitution Update Proposal` when `mode=architecture` shows a system-level rule change is needed

### `specify`

Use the review prompts to strengthen specs with:

- Explicit module boundaries.
- Contract expectations.
- Validation boundaries.
- Data ownership.
- Response and output consistency.
- Accepted architecture constraints from the Constitution.

### `plan`

Use the review prompts to inspect the plan for:

- Missing abstractions.
- Unclear ownership.
- Cross-module coupling.
- Direct data access.
- Contract drift.
- Places where a framework adapter may be useful.

### `tasks`

Use the refactor generator to produce non-blocking tasks from detected violations.

Tasks should be scoped, prioritized, and actionable. They should not stop feature implementation unless the Constitution explicitly marks the architecture rule as blocking.

### `implement`

Use the architecture review prompt after implementation to:

- Compare implementation to the Constitution.
- Identify drift.
- Produce refactor tasks.
- Verify consistency with nearby modules.
- Preserve delivery momentum.

### `apply`

Use the write-capable architecture apply prompt to update planning artifacts directly when the team approves the refactor.

This is the command to use when the architecture review should become an actual task or plan update rather than a recommendation only.

## Common Misunderstandings

- This is not a static analyzer.
- This is not a security review replacement.
- Performance analysis is optional and advisory.
- Performance analysis does not replace benchmarking or profiling.
- Constitution updates are never automatic.
- This is not framework-specific in the core package.
- This is not read-only only, because `architecture-apply` can update planning artifacts when requested.
- This is not a blocker by default.

## Output Format Standard

All architecture review output should follow this structure:

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

When performance mode is active, append:

```text
Performance Insights:
- Suggestion:
- Context:
- Trade-off:
```

Severity values:

- `Critical`: Violates a blocking Constitution rule or creates immediate architectural breakage.
- `High`: Creates significant coupling, boundary erosion, or contract inconsistency.
- `Medium`: Introduces local drift that may spread if repeated.
- `Low`: Minor inconsistency or naming or shape drift worth cleaning up later.

Priority values:

- `P0`: Must resolve before release because the Constitution makes it blocking.
- `P1`: Should resolve soon to prevent architectural spread.
- `P2`: Safe to schedule as technical debt.
- `P3`: Opportunistic cleanup.

## Example Output

```text
Architecture Review

Constitution Alignment:
- Status: Partially aligned
- Notes: The implementation follows the feature boundary but bypasses the established contract layer.

Violations:
- Type: Missing Data Contract
  Severity: Medium
  Location: Order creation endpoint
  Description: The endpoint accepts raw request data and forwards it directly to application logic.
  Evidence: Request fields are read inline without a request DTO, schema, interface, or equivalent contract.
  Principle: Input boundaries should normalize and validate data before application logic receives it.

Refactor Tasks:
[Refactor Task]
Title: Introduce an order creation input contract
Reason: The current endpoint passes unstructured request data into application logic, increasing contract drift risk.
Scope: Order creation request boundary and application service input.
Priority: P2
Suggested Fix: Define a request contract for order creation, validate incoming data at the boundary, and pass the normalized contract to the application service.

Consistency Notes:
- Modules: Order module is less explicit than nearby account and billing modules.
- Services: Service entry point is usable but should depend on a normalized input shape.
- Handlers/Controllers: Handler contains light mapping logic only after refactor.
- Data Contracts: Add request and response contract definitions.

Summary:
- Overall Risk: Medium
- Recommended Next Step: Continue implementation, then schedule the refactor task before expanding order workflows.
```

## Non-Goals

This extension does not:

- Duplicate `security-review`.
- Make performance analysis mandatory.
- Replace benchmarking or profiling.
- Auto-update the Constitution.
- Require runtime tools.
- Act as a linter or static analyzer.
- Enforce framework-specific conventions in the core package.
- Block implementation by default.

## Incremental Adoption

Adopt this extension gradually:

1. Start by reviewing one feature or module.
2. Record recurring decisions in the Constitution or memory context.
3. Generate refactor tasks instead of blocking implementation.
4. Promote repeated refactor tasks into explicit architecture rules.
5. Add a framework adapter only when generic guidance is no longer precise enough.
