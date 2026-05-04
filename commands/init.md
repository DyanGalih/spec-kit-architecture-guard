# `init.md`

---

## description: Initialize or refine the project governance and architecture constitutions for Architecture Guard.

# Purpose

This command helps teams intentionally define:

* engineering governance principles
* architecture boundaries
* enforcement standards
* validation and contract rules
* architecture evolution policies

This command generates or refines:

* `constitution.md`
* `architecture_constitution.md`
* `.claude/prompts/architecture-guard-adapter.md` (Optional Framework Preset)

The goal is NOT to generate generic best practices.

The goal is to establish:

* enforceable rules
* clear boundaries
* long-term consistency
* architecture evolution discipline
* project-specific standards

---

# Core Principles

## 1. Sequential Interviewing

DO NOT ask all questions at once.

Interview the user in logical phases.

Only continue when the current phase is sufficiently understood.

---

## 2. Context-Aware Guidance

Adapt vocabulary and suggestions based on:

* framework
* architecture style
* project maturity
* existing conventions
* existing constitution files

Examples:

* Laravel → Controllers, Form Requests, Actions, Eloquent
* NestJS → Controllers, Providers, DTOs, Modules
* Next.js → Server Components, Server Actions, Zod
* Nuxt → Composables, Pinia, server/api

---

## 3. Suggestions, Not Forced Opinions

Reference patterns are suggestions.

NEVER force architecture opinions into the Constitution.

A rule only becomes a standard when:

* the user explicitly accepts it
* OR the project already consistently follows it

---

## 4. Architecture Before Implementation

Prioritize:

* boundaries
* ownership
* responsibilities
* contracts
* dependency direction

before implementation details.

---

## 5. Explicit Standards Only

Avoid vague guidance.

BAD:

```text
Follow best practices
```

GOOD:

```text
Controllers must delegate business logic to Services or Actions.
```

---

## 6. Constitution Changes Must Be Intentional

NEVER automatically evolve architecture direction.

If architecture drift is detected:

* summarize the drift
* explain impact
* propose evolution
* require explicit approval

---

## 7. Layered Constitution Strategy

This system separates:

* governance principles
* architecture enforcement rules

The system must maintain:

* `constitution.md`
* `architecture_constitution.md`

Avoid duplication between both files.

---

# Constitution Responsibilities

---

## `constitution.md`

Purpose:

High-level governance and engineering philosophy.

Should contain:

* engineering philosophy
* testing standards
* security expectations
* documentation standards
* review expectations
* operational expectations
* high-level architecture intent

Should NOT contain:

* controller implementation details
* DTO implementation specifics
* framework-specific structure rules
* module folder naming conventions

---

## `architecture_constitution.md`

Purpose:

Enforceable architecture standards and system boundaries.

Should contain:

* layer boundaries
* business logic placement
* validation flow
* DTO/schema standards
* module ownership rules
* async boundaries
* API contract rules
* framework-specific architectural conventions
* architecture evolution rules

---

# Initialization Logic

## Step 1 — Detect Existing Constitution Files

Check for:

* `constitution.md`
* `architecture_constitution.md`

---

## If BOTH files exist

1. Summarize:

* governance principles
* architecture rules
* duplicated rules
* conflicting standards
* unclear sections

2. Ask:

```text
Would you like to:
- refine governance rules
- refine architecture rules
- reduce duplication
- evolve architecture direction
- regenerate one of the files
```

3. NEVER overwrite rules automatically.

---

## If ONLY `constitution.md` exists

1. Analyze architecture-related sections.

2. Detect rules that should move into:

```text
architecture_constitution.md
```

3. Ask:

```text
Would you like to split architecture rules into a dedicated architecture constitution?
```

---

## If NO constitution files exist

Start phased initialization interview.

---

# Interview Flow

---

# Phase 1 — Project Identity & Architecture Style

Determine:

* technology stack
* architecture style
* runtime boundaries
* application type
* deployment shape

---

## Questions

### Technology Stack

Ask:

```text
What is the primary technology stack?

Examples:
- Laravel 12 + Inertia React
- NestJS 10
- Next.js 15 App Router
- Nuxt 3
- Express + React
```

### Framework Preset (Adapter)

If the technology stack matches a built-in preset (e.g., Laravel), ask:

```text
Would you like to install the [Framework] Architecture Adapter?

This will:
1. Install a framework-specific preset to .claude/prompts/architecture-guard-adapter.md
2. Automatically configure the engine to be [Framework]-aware.
3. Provide specialized detection for [Framework] anti-patterns.
```

---

### Architecture Style

Ask:

```text
What architecture style does this project follow?

- Monolith
- Modular Monolith
- Microservices
- Event-Driven
- Hybrid
```

---

### Application Type

Ask:

```text
What type of application is this?

Examples:
- REST API
- Full-stack web app
- Internal dashboard
- Public SaaS
- Realtime platform
- Background processing system
```

---

# Architecture-Aware Branching

---

## If Monolith

Focus on:

* layering
* separation of concerns
* entry-point discipline

---

## If Modular Monolith

Focus on:

* module ownership
* cross-module access
* shared contracts
* dependency direction

---

## If Microservices

Focus on:

* service ownership
* API contracts
* event communication
* shared database restrictions
* service boundaries

---

# Framework-Specific Interview Logic

---

## Laravel

Ask:

```text
What application style are you using?

- REST API
- Inertia
- Livewire
- API + SPA
```

---

Ask:

```text
Where should business logic live?

- Services
- Actions
- Domain layer
- Models
- Hybrid
```

---

Ask:

```text
How should validation be handled?

Examples:
- Form Requests
- DTO validation
- inline validation
```

---

## NestJS

Ask:

```text
How strict should module boundaries be?
```

---

Ask:

```text
Should services communicate directly or through contracts/events?
```

---

## Next.js

Ask:

```text
How should Server and Client Component boundaries be enforced?
```

---

Ask:

```text
Should Server Actions delegate to domain/service layers?
```

---

## Nuxt / Vue

Ask:

```text
How should composables be organized and scoped?
```

---

Ask:

```text
How should API access be abstracted?
```

---

# Phase 2 — Business Logic & Boundaries

Determine:

* business logic ownership
* dependency direction
* layer responsibilities
* boundary isolation

---

## Questions

Ask:

```text
Where should business logic live?
```

---

Ask:

```text
Which layers may communicate directly?
```

---

Ask:

```text
Should the domain layer remain isolated from transport layers such as HTTP, queues, or UI?
```

---

Ask:

```text
How strict should module boundaries be enforced?
```

---

# Phase 3 — Contracts & Validation

Determine:

* validation strategy
* request/response contracts
* serialization standards
* frontend/backend boundaries

---

## Questions

Ask:

```text
How should input validation be handled?
```

---

Ask:

```text
What is the standard response structure?
```

---

## Framework-Specific Questions

### Laravel + Inertia

Ask:

```text
How should PHP → frontend contracts be protected?

Examples:
- DTOs
- API Resources
- TypeScript interfaces
- explicit field mapping
```

---

### NestJS

Ask:

```text
Should validation be global or scoped per controller/module?
```

---

### Next.js

Ask:

```text
How should Server Action inputs be validated?
```

---

# Phase 4 — Data Access & Async Rules

Determine:

* ORM strategy
* repository usage
* query ownership
* async boundaries
* background processing rules

---

## Questions

Ask:

```text
How should data access be handled?

Examples:
- direct ORM usage
- repositories
- query services
- domain repositories
```

---

Ask:

```text
When should async processing be required?
```

---

Ask:

```text
Which operations must never block requests?
```

---

# Phase 5 — Enforcement & Evolution

Determine:

* blocking rules
* architecture governance
* evolution policies
* intentional deviations

---

## Questions

Ask:

```text
Which rules should be treated as blocking violations (P0)?
```

---

Ask:

```text
Are there intentional architectural deviations that should be documented?
```

---

Ask:

```text
How should architecture evolution be handled?

Examples:
- manual review only
- proposal-based evolution
- strict governance
```

---

# Rule Classification Logic

Before generating rules, classify them.

---

## Global Governance Rules → `constitution.md`

Examples:

* testing philosophy
* documentation standards
* security requirements
* review expectations
* engineering philosophy
* operational governance

---

## Architecture Enforcement Rules → `architecture_constitution.md`

Examples:

* controller/service boundaries
* DTO requirements
* validation placement
* async boundaries
* response contracts
* module ownership rules
* framework-specific architecture patterns

---

# Duplication Prevention Rules

DO NOT duplicate rules across both files.

If a rule exists in:

```text
architecture_constitution.md
```

Then:

```text
constitution.md
```

should reference architecture rules instead of repeating implementation details.

---

GOOD:

```text
constitution.md:
- Architecture enforcement rules are defined in architecture_constitution.md
```

```text
architecture_constitution.md:
- Controllers must delegate business logic to Services or Actions
```

---

BAD:

Duplicating detailed architecture rules in both files.

---

# Constitution Synthesis Rules

DO NOT generate final documents until:

* enough information has been collected
* OR the user explicitly requests a draft

---

# Output Requirements

Generate or refine:

* `constitution.md`
* `architecture_constitution.md`
* `.claude/prompts/architecture-guard-adapter.md` (if preset selected)

### Preset Installation

If a preset was selected (e.g., Laravel):
1. Copy `presets/[framework].md` from the extension directory to `.claude/prompts/architecture-guard-adapter.md` in the project.
2. This ensures the core engine uses the framework-specific "Brain" during all architecture reviews.

---

## `constitution.md` Structure

```text
1. Project Identity
2. Engineering Philosophy
3. Security Expectations
4. Testing Expectations
5. Documentation Standards
6. Review Process
7. High-Level Architecture Intent
8. Governance and Evolution Policy
```

---

## `architecture_constitution.md` Structure

```text
1. Architecture Style
2. Layer Boundaries
3. Business Logic Placement
4. Contracts & Validation
5. Data Access Rules
6. Async & Integration Rules
7. Module Boundaries
8. Framework-Specific Architecture Rules
9. Blocking Architecture Violations (P0)
10. Architecture Evolution Policy
11. Refactor & Drift Handling
```

---

# Architecture Evolution Rules

Architecture rules may evolve over time.

When repeated architecture drift is detected:

* generate Constitution Update Proposals
* target `architecture_constitution.md` by default
* only propose updates to `constitution.md` for governance-level changes

NEVER automatically modify either file.

---

# Reference Patterns

These are guidance patterns.

DO NOT automatically enforce them.

---

## Laravel Reference Patterns

* Thin Controllers
* Form Requests for validation
* Business logic in Services or Actions
* Explicit frontend contracts for Inertia
* Avoid leaking raw models to frontend
* Separate HTTP entry layer from domain logic

---

## NestJS Reference Patterns

* Thin Controllers
* Business logic in Services
* Strong Module boundaries
* DTO validation with ValidationPipe
* Explicit imports/exports between modules

---

## Next.js Reference Patterns

* Clear Server vs Client boundaries
* Server Components for data loading
* Avoid heavy logic in Server Actions
* Validate inputs using schemas
* Prefer Server Actions over unnecessary API routes

---

## Nuxt / Vue Reference Patterns

* Thin API handlers
* Organized composables
* Controlled global state
* Dedicated API abstraction layer
* Middleware only for cross-cutting concerns

---

# Final Rules

This command exists to help teams intentionally design:

* governance standards
* architecture boundaries
* evolution policies
* enforceable engineering systems

It must NOT:

* generate vague advice
* blindly enforce trends
* automatically rewrite architecture direction
* duplicate rules across constitutions

The generated constitutions must reflect intentional engineering decisions.
