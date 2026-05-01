# 🛡️ Architecture Guard

> Continuous architecture governance for AI-assisted development.

[![Version](https://img.shields.io/badge/version-1.1.2-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Optional adapters](https://img.shields.io/badge/adapters-optional-8b5cf6)](adapters/README.md)

---

# What Is This?

Architecture Guard is a Spec Kit extension for architecture governance.

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
| `architecture-workflow` | Recommended entry point. Runs architecture review workflow end-to-end.               |
| `architecture-review`   | Reviews specifications, plans, tasks, or implementations against architecture rules. |
| `violation-detection`   | Detects architecture drift and boundary violations.                                  |
| `refactor-generator`    | Converts violations into structured refactor tasks.                                  |
| `architecture-apply`    | Applies approved architecture changes into planning artifacts.                       |

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

| Spec Kit Phase | Optional Spec Kit Follow-up | Recommended Architecture Guard Command | Purpose |
| --- | --- | --- | --- |
| `specify` | `clarify` | `architecture-review` | Validate ownership, contracts, and architecture boundaries before planning |
| `plan` | — | `architecture-review` | Validate technical plan against architecture standards |
| `tasks` | `analyze` | `violation-detection` | Detect coupling, boundary violations, and architecture drift before implementation |
| — | — | `refactor-generator` | Convert architecture issues into structured migration/refactor tasks |
| `implement` | — | `architecture-review` | Re-check implementation against architecture standards |
| any phase | — | `architecture-workflow` | Run a complete architecture governance pass |

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

# Command Modes

Commands support optional modes and focus scopes.

---

## Architecture Mode (default)

Strict architecture review.

Produces:

* violations
* refactor tasks
* consistency analysis

Example:

```text
/architecture-review
```

---

## Performance Mode

Advisory-only architecture performance review.

Produces:

* Performance Insights

Does NOT produce:

* violations
* refactor tasks

Example:

```text
/architecture-review performance
/architecture-review performance db
```

---

## Focus Areas

Supported focus areas:

```text
- general
- db
- api
- async
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

Adapters do NOT replace architecture constitutions.

Project-specific standards must always live in:

```text
architecture_constitution.md
```

Example adapters:

* `architecture-guard-laravel`
* `architecture-guard-nestjs`
* `architecture-guard-nextjs`

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
cd /path/to/spec-kit-project
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.1.2.zip
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

Architecture Guard does NOT:

* replace security review
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
