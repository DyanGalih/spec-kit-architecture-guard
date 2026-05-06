# 🛡️ Architecture Guard

> Continuous architecture governance for AI-assisted development.

[![Version](https://img.shields.io/badge/version-1.6.5-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Orchestration](https://img.shields.io/badge/role-governance--orchestrator-blue)](https://spec-kit.dev)
[![Optional adapters](https://img.shields.io/badge/adapters-optional-8b5cf6)](adapters/README.md)

---

# What Is This?

Architecture Guard is a modular **architecture governance orchestration layer** for Spec Kit.

It reviews specifications, plans, task lists, and implementations against your project's architecture standards and produces:

* architecture drift detection
* structured refactor tasks
* consistency reviews
* architecture evolution proposals
* incremental migration guidance

Architecture Guard helps teams continuously enforce and evolve architecture standards during AI-assisted development.

It answers one question throughout delivery:

> Does this still align with the architecture we agreed on?

---

# The Problem It Solves

AI-generated code usually optimizes for:

* speed
* local correctness
* immediate implementation success

It does NOT naturally preserve architectural consistency.

Over time this creates drift:

* business logic leaks into controllers or route handlers
* direct database access bypasses established boundaries
* inconsistent response contracts appear across modules
* modules reach into each other's internals
* new features introduce slightly different patterns

Each issue looks small in isolation.

After enough features:

* boundaries weaken
* contracts drift
* architecture becomes inconsistent
* technical debt spreads silently

Architecture Guard detects these drifts early and converts them into structured, visible, non-blocking architecture work.

---

# What It Actually Does

| Phase                  | What Happens                                                | Output                                       |
| ---------------------- | ----------------------------------------------------------- | -------------------------------------------- |
| Specification          | Reviews ownership, boundaries, contracts                    | Missing boundaries or unclear ownership      |
| Planning               | Detects coupling and architecture drift                     | Warnings before implementation hardens       |
| Task Generation        | Converts violations into structured refactor work           | Prioritized refactor tasks                   |
| Implementation         | Re-checks implementation against architecture rules         | Drift detection and consistency review       |
| Architecture Evolution | Detects repeated patterns and proposes architecture updates | Constitution Update Proposals                |
| Approved Changes       | Applies accepted updates into planning artifacts            | Updated tasks/plans via `architecture-apply` |

---

# Key Philosophy: Non-Blocking Architecture Governance

Architecture Guard is intentionally non-blocking by default.

Violations become:

* refactor tasks
* migration tasks
* architecture proposals

—not hard errors.

Example:

```text
[Refactor Task]
Title: Move pricing rule out of checkout handler
Reason: The handler currently owns business decisions that belong in the application layer.
Scope: Checkout handler and checkout application service.
Priority: P1
Suggested Fix: Extract pricing logic into the checkout service and keep the handler responsible for validation and delegation only.
```

Only rules explicitly marked as `P0` in the architecture constitution should block delivery.

---

# Layered Constitution Model

Architecture Guard separates:

* engineering governance
* architecture enforcement

into two different documents.

---

## `constitution.md`

Defines:

* engineering philosophy
* testing expectations
* security expectations
* documentation standards
* review standards
* governance principles

This file should remain relatively stable.

---

## `architecture_constitution.md`

Defines:

* layer boundaries
* business logic placement
* validation standards
* module boundaries
* response contracts
* async boundaries
* framework-specific architecture rules
* architecture evolution policies

Architecture Guard primarily validates against:

```text
architecture_constitution.md
```

This separation prevents implementation-level architecture rules from polluting broader engineering governance.

---

# Benefits

## Compared to Spec Kit Alone

| Spec Kit Only                                          | Spec Kit + Architecture Guard                            |
| ------------------------------------------------------ | -------------------------------------------------------- |
| AI starts each feature independently                   | AI checks work against architecture standards            |
| Drift accumulates silently                             | Drift becomes visible and actionable                     |
| Architecture inconsistencies appear during code review | Inconsistencies are detected earlier                     |
| Constitution exists passively                          | Constitution becomes actively enforced                   |
| No structured architecture debt tracking               | Violations become prioritized refactor tasks             |
| Architecture evolution is manual and inconsistent      | Architecture evolution becomes structured and reviewable |

---

## Compared to Static Analyzers

| Static Analyzers              | Architecture Guard                      |
| ----------------------------- | --------------------------------------- |
| Language-specific tooling     | Framework-agnostic architecture review  |
| Syntax and code-pattern focus | Architecture and boundary focus         |
| Build-time blocking           | Non-blocking by default                 |
| Generic rules                 | Project-specific architecture rules     |
| Runtime/tooling dependencies  | Prompt-based with no runtime dependency |

---

# When To Use It

Use Architecture Guard when:

* your project has meaningful boundaries
* AI-generated code introduces inconsistencies
* multiple developers contribute to architecture decisions
* architectural patterns should remain consistent
* architecture drift is increasing over time
* you want visible architecture debt instead of hidden drift
* you want architecture evolution to be intentional

---

## Best Fit

* modular monoliths
* microservices
* large full-stack applications
* shared API/UI contract systems
* long-lived codebases
* systems where consistency matters more than framework purity

---

# When NOT To Use It

Do NOT use Architecture Guard for:

* tiny projects with no meaningful architecture
* throwaway prototypes
* one-off scripts
* projects with no agreed architectural direction
* teams unwilling to maintain architecture standards
* replacing benchmarking or profiling workflows

If you can fully manage architecture mentally and you are the only contributor, this extension may be unnecessary overhead.

---

# Prerequisites

Architecture Guard depends on architecture standards.

Without architecture rules, the extension has nothing meaningful to validate against.

---

# Initialize Your Constitutions

Run:

```text
/speckit.architecture-guard.init
```

This command can:

* initialize constitutions
* refine existing constitutions
* split governance and architecture rules
* detect duplicated architecture standards
* generate architecture enforcement rules

It may generate:

```text
constitution.md
architecture_constitution.md
```

---

## What The Initializer Defines

### Governance Standards

Examples:

* testing expectations
* documentation standards
* review policies
* engineering philosophy

---

### Architecture Standards

Examples:

* business logic placement
* validation boundaries
* response contracts
* module ownership
* async boundaries
* layering rules

---

## Architecture Evolution Support

The initializer also supports:

* constitution refinement
* architecture evolution
* migration planning
* architecture standard extraction

---

By using explicit markdown files, extensions remain decoupled, and all constraints and decisions are fully reviewable in Git.

---

# Governed Planning Workflow

Architecture Guard can orchestrate planning workflows across Memory Hub, Security Review, and Architecture Guard validation when companion extensions are installed.

**The Orchestrated Workflow:**

1. **Memory Synthesis**: Scoped retrieval of historical decisions (`memory-synthesis.md`).
2. **Plan Generation**: Spec Kit technical planning (`plan.md`).
3. **Security Validation**: Review plan against trust boundaries (`security-constraints.md`).
4. **Architecture Validation**: Detect drift and security-architecture conflicts (`architecture-findings.md`).
5. **Governance Summary**: Final overview of architecture and security risks.

### Example Orchestration

```text
/speckit.architecture-guard.governed-plan
```

---

## Governed Task and Implementation Workflows

Architecture Guard can orchestrate governance checks throughout the implementation lifecycle when companion extensions are installed.

### Governed Tasks

Runs task generation with optional memory context, then checks whether security and architecture work are represented in the task list.

**Flow:**
memory synthesis → tasks → security task review → architecture refactor generation → task governance summary

```text
/speckit.architecture-guard.governed-tasks
```

### Governed Implement

Runs implementation with optional memory context, then reviews the result against security and architecture constraints.

**Flow:**
memory synthesis → implement → security review → architecture review → refactor/fix recommendations

```text
/speckit.architecture-guard.governed-implement
```

> [!IMPORTANT]
> **Companion extensions are optional.** Architecture Guard degrades gracefully and does not require Memory Hub or Security Review to function. It orchestrates workflows only when companion artifacts or extensions are available.

---

# Quick Start

## 1. Install

```text
cd /path/to/spec-kit-project
specify extension add architecture-guard
```

---

## 2. Initialize Constitutions

```text
/speckit.architecture-guard.init
```

---

## 3. Run Architecture Workflow

```text
/speckit.architecture-guard.architecture-workflow
```

---

## 4. Review Violations and Refactor Tasks

```text
/speckit.architecture-guard.architecture-apply
```

---

# Commands

| Command                 | Purpose                                                                              |
| ----------------------- | ------------------------------------------------------------------------------------ |
| `governed-plan`         | **Orchestrator**. Coordinates Memory, Planning, Security, and Architecture.           |
| `governed-tasks`        | **Orchestrator**. Runs task generation with memory, security, and architecture.      |
| `governed-implement`    | **Orchestrator**. Runs implementation then validates security and architecture.       |
| `architecture-workflow` | Recommended entry point for general reviews. Runs review workflow end-to-end.        |
| `architecture-review`   | Reviews specifications, plans, tasks, or implementations against architecture rules. |
| `violation-detection`   | Detects architecture drift and boundary violations.                                  |
| `refactor-generator`    | Converts violations into structured refactor tasks.                                  |
| `architecture-apply`    | Applies approved architecture changes into planning artifacts.                       |
| `init`                  | Initializes or refines architecture and governance constitutions.                    |

> [!TIP]
> `architecture-apply` targets `plan.md` and `tasks.md`. If architectural issues are found in the specification stage, refine the specification before generating a technical plan.

---

# Recommended Architecture Validation Flow

Architecture Guard is a **post-phase architecture validation and evolution layer** on top of Spec Kit workflows. It does not replace Spec Kit phases; it validates the architectural alignment of the artifacts they create.

---

### The Mental Model

| System | Role |
| --- | --- |
| **Spec Kit** | Creates delivery artifacts (specs, plans, tasks, code) |
| **Architecture Guard** | Validates architectural alignment of those artifacts |

---

Architecture Guard commands are **manually invoked** unless integrated into a custom workflow automation.

## Suggested Validation Flow

Architecture Guard commands are optional follow-up validation steps that can be run after Spec Kit phases. They are intended to review architecture alignment before implementation drift spreads further.

| Milestone | Recommended Command | Phase Integration | Purpose |
| --- | --- | --- | --- |
| **Milestone: Boundaries** | `architecture-review` | After `specify` | Validate ownership and contracts early before planning. |
| **Milestone: Strategy** | `governed-plan` | After `specify` | Orchestrated planning with memory, security, and architecture review. |
| **Milestone: Execution** | `governed-tasks` | After `plan` | Generate tasks with governance checks and architecture migration awareness. |
| **Milestone: Delivery** | `governed-implement` | After `tasks` | Implement and review output against memory, security, and architecture. |
| **Milestone: Evolution** | **`architecture-apply`** | After review/detection | **Inject approved refactor tasks** into Plan and Task artifacts. |
| **Milestone: Verification** | `architecture-review` | After `implement` | Final check of the actual code against architecture rules. |
| **Milestone: Complete Pass** | `architecture-workflow` | Anytime | Run a complete review pass including evolution proposals. |

---

## How to Handle Violations

Architecture Guard identifies drift, but you decide how to resolve it based on the stage of your development.

### 1. In the Specification Stage
If `architecture-review` finds boundary or contract issues in your spec:
1. **Refine**: Run `/specify` again with additional instructions (e.g., `/specify - please move business logic from the entry point to the domain layer`).
2. **Verify**: Run `architecture-review` again to ensure the status is **Aligned**.
3. **Proceed**: Only then run `/plan`.

### 2. In the Planning or Implementation Stage
If drift is detected in your technical plan or task list:
1. **Review**: Check the `Refactor Tasks` generated by the review.
2. **Apply**: Run `/speckit.architecture-guard.architecture-apply`.
3. **Implement**: The AI will now have explicit refactor steps in its task list to fix the architectural debt while building the feature.

---

### Example Workflow: Specification

```text
/specify
↓
/clarify
↓
No major ambiguity found
↓
/speckit.architecture-guard.architecture-review
```

### Example Workflow: Tasks & Analysis

```text
/plan
↓
/tasks
↓
/analyze
↓
Architecture complexity increased
↓
/speckit.architecture-guard.violation-detection
```

For most teams, `architecture-workflow` is the safest default because it runs the complete architecture governance pass in one command.

---

# Command Options: Modes & Focus

You can refine any Architecture Guard command using **Modes** and **Focus Areas** to target specific architectural concerns.

| Option | Type | Default | Purpose |
| --- | --- | --- | --- |
| `architecture` | **Mode** | Yes | **Corrective**: Produces violations and refactor tasks. |
| `performance` | **Mode** | No | **Advisory**: Produces high-level performance insights and trade-offs. |
| `general` | **Focus** | Yes | Reviews all boundaries (Entry, Domain, Data, etc.). |
| `db` | **Focus** | No | Targets database schema, query patterns, and persistence logic. |
| `api` | **Focus** | No | Targets request/response contracts, versioning, and endpoint design. |
| `async` | **Focus** | No | Targets jobs, events, broadcasting, and background processing. |

> [!NOTE]
> **Stack Agnostic Design**: These focus areas target universal **Architecture Primitives**. Whether you are using Laravel, NestJS, Go, or Python, the engine maps these areas to your project's specific boundaries as defined in your Constitution.

---

### Behavior Comparison

| Feature | `mode=architecture` | `mode=performance` |
| --- | --- | --- |
| **Goal** | Governance & Drift Detection | Optimization & Scalability |
| **Output** | Violations + Refactor Tasks | Performance Insights Only |
| **Blocking** | Yes (if rule is P0) | No (Always advisory) |

---

### Enterprise Examples

**1. Standard Architecture Review**
```text
/speckit.architecture-guard.architecture-review
```

**2. Deep Database Performance Audit**
```text
/speckit.architecture-guard.architecture-review performance db
```

**3. API Contract & Versioning Review**
```text
/speckit.architecture-guard.architecture-review api
```

**4. Async Workflow Performance Check**
```text
/speckit.architecture-guard.architecture-review performance async
```

---

# Architecture Evolution Workflow

Architecture Guard supports controlled architecture evolution.

Recommended workflow:

```text
New architecture standard
↓
Update architecture_constitution.md
↓
architecture-review detects drift
↓
refactor-generator creates migration tasks
↓
architecture-apply applies approved changes
```

Example:

```text
Adopt FormRequest validation
↓
Detect inline validation drift
↓
Generate incremental migration tasks
```

Architecture Guard encourages:

* progressive migration
* scoped refactors
* module-by-module adoption

instead of large rewrite tasks.

---

# Companion Extensions

## Memory Hub

Provides:

* durable project memory
* historical decisions
* feature synthesis context

Architecture Guard can use this context but does not require it.

---

## Security Review

Handles:

* secrets
* injection risks
* authorization
* authentication
* security-first findings

Architecture Guard only keeps findings that are also architecture boundary problems.

---

# Responsibility Split

| Extension          | Responsibility                                                                             |
| ------------------ | ------------------------------------------------------------------------------------------ |
| Architecture Guard | Architecture boundaries, layering, contracts, consistency, drift detection, refactor tasks |
| Memory Hub         | Durable project memory and context                                                         |
| Security Review    | Security validation and security-focused review                                            |

---

# Framework-Agnostic Design

Architecture Guard uses architecture concepts instead of framework-specific implementation names.

| Architecture Concept | Examples                                         |
| -------------------- | ------------------------------------------------ |
| Entry Boundary       | Controller, route handler, resolver, page action |
| Contract Boundary    | DTO, schema, request object, response object     |
| Application Boundary | Service, use case, handler                       |
| Domain Boundary      | Business rule, policy, domain model              |
| Data Boundary        | Repository, query service, gateway               |

---

# Optional Adapters

Adapters are optional enhancement layers.

They provide:

* framework-specific vocabulary
* framework-aware examples
* stronger interpretation guidance
* better support for smaller AI models

architecture_constitution.md
```

## Built-in Framework Presets

Architecture Guard now includes built-in framework presets (Adapters) that can be installed during the `init` phase. These presets automatically configure the engine with framework-specific knowledge, anti-pattern detection, and boundary mapping.

Currently available presets:
- **Laravel**: Full support for Controllers, Form Requests, Actions, API Resources, Eloquent, Inertia, and Livewire patterns.
- **NestJS**: Specialized for Module boundaries, Dependency Injection, and DTO enforcement.
- **Next.js**: Optimized for App Router, Server Components, and Server Actions.
- **Nuxt.js**: Focus on Nitro routes, Composables, and Nuxt directory standards.
- **Django**: Enforces MVT separation and handles the "Fat Model" vs "Service Layer" patterns.
- **Spring Boot**: Enforces Controller-Service-Repository patterns and DTO isolation in Java.
- **React**: Focus on Component/Logic separation, Custom Hooks, and API abstraction.
- **Vue**: Focus on Composition API standards, Composables, and Pinia store boundaries.
- **Express.js**: Enforces basic Controller-Service-Repository patterns in Node.js.

To use a preset:
1. Run `/speckit.architecture-guard.init`.
2. Follow the interview and select your framework when prompted.
3. The preset will be installed to `.claude/prompts/architecture-guard-adapter.md`.

---

# Output Format

## Architecture Review

```text
Architecture Review

Constitution Alignment:
- Status: [Aligned / Partially aligned / Misaligned]
- Notes: [Explanation]

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

Performance Insights:
- Suggestion:
- Context:
- Trade-off:

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

Summary:
- Overall Risk:
- Recommended Next Step:
```

---

# Severity and Priority Reference

| Severity | Meaning                                  |
| -------- | ---------------------------------------- |
| Critical | Violates blocking architecture rule      |
| High     | Cross-boundary drift that spreads easily |
| Medium   | Local drift likely to spread             |
| Low      | Minor inconsistency                      |

---

| Priority | Meaning                     |
| -------- | --------------------------- |
| P0       | Must resolve before release |
| P1       | Should resolve soon         |
| P2       | Safe as technical debt      |
| P3       | Opportunistic cleanup       |

---

# Installation

## Registry Installation

```text
cd /path/to/spec-kit-project
specify extension add architecture-guard
```

---

## GitHub Installation

```text
  specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.6.4.zip
```

---

## Local Development

```text
cd /path/to/spec-kit-project
specify extension add --dev /path/to/spec-kit-architecture-guard
```

---

# Incremental Adoption Strategy

Recommended adoption strategy:

1. Start with one feature review.
2. Define architecture rules gradually.
3. Use refactor tasks instead of blocking delivery.
4. Promote repeated patterns into architecture standards.
5. Evolve architecture intentionally.
6. Add adapters only when framework-specific guidance becomes necessary.

---

# Relationship to Governance Extensions

Architecture Guard focuses specifically on:

* architecture enforcement
* architecture consistency
* architecture drift detection
* architecture evolution
* migration guidance

It is NOT a full governance or compliance framework.

It complements:

* security review systems
* governance systems
* memory/context systems

rather than replacing them.

---

# Non-Goals

Architecture Guard orchestration does not replace Spec Kit tasks or implement commands. It coordinates optional governance checks around them.

Architecture Guard does NOT:

* replace Spec Kit planning
* replace Spec Kit tasks or implement commands
* replace security review systems
* replace memory systems
* automatically enforce architecture rewrites
* replace profiling or benchmarking
* act as a linter or static analyzer
* auto-update constitutions
* require runtime tooling
* enforce framework-specific conventions globally
* block implementation by default

---

# Final Philosophy

Architecture Guard exists to help teams:

* preserve architecture consistency
* detect architecture drift early
* evolve architecture intentionally
* keep architectural debt visible
* support AI-assisted development without losing architectural direction

The goal is not perfect architecture purity.

The goal is controlled, intentional architectural evolution.
