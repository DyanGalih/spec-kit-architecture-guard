# 🛡️ Architecture Guard

[![Version](https://img.shields.io/badge/version-1.0.9-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Optional adapters](https://img.shields.io/badge/adapters-optional-8b5cf6)](adapters/README.md)

## What Is This?

Architecture Guard is a Spec Kit extension that **reviews your AI-generated code against your project's architectural rules** and produces structured, non-blocking refactor tasks when it finds violations.

It answers one question at every stage of delivery:

> Does this work still fit the architecture we agreed on?

## The Problem It Solves

When you use AI to build features, the AI writes code that works — but it doesn't know your project's rules:

- It puts business logic in a controller because the controller is the file it's editing
- It queries the database directly because that's the fastest path
- It invents a new response format because it doesn't know you standardized on `{ data, meta, errors }`
- It reaches into another module's internals because they're in the same repo

Each violation is small. But after 10 features, your codebase has 10 different patterns, and no one remembers which one is correct.

**Architecture Guard catches these drifts early** by reviewing every spec, plan, task list, and implementation against your Constitution — the document that defines your project's architectural rules.

## What It Actually Does

| When | What Happens | Output |
| --- | --- | --- |
| You write a **spec** | Guard checks boundaries, contracts, and ownership | Flags missing contracts or unclear module boundaries |
| You write a **plan** | Guard detects coupling, missing abstractions, and contract drift | Warns before the design hardens |
| You generate **tasks** | Guard converts violations into scoped refactor tasks | Actionable tasks with priority (P0–P3) |
| You **implement** | Guard re-checks code against the Constitution | Produces refactor tasks without blocking delivery |
| You **approve a fix** | Guard writes the update into your plan/tasks | Updated planning artifacts via `architecture-apply` |

### Key Behavior: Non-Blocking

Violations produce **refactor tasks**, not errors. You finish your feature first. Then you address the architectural debt as structured, prioritized work.

```text
[Refactor Task]
Title: Move pricing rule out of checkout handler
Reason: The handler currently owns a business decision that belongs in the domain layer.
Scope: Checkout handler and checkout application service.
Priority: P1
Suggested Fix: Extract pricing logic into the checkout service, keep the handler for validation and delegation only.
```

Only rules you explicitly mark as `P0` in your Constitution will block implementation.

## Benefits

### Compared to Spec Kit Alone

| Spec Kit Only | Spec Kit + Architecture Guard |
| --- | --- |
| AI starts each feature from scratch | AI checks its work against your architectural rules |
| Drift accumulates silently across features | Drift is caught and turned into visible, scoped tasks |
| Team discovers inconsistencies during code review | Guard flags inconsistencies before code review |
| No structured way to track architectural debt | Every violation becomes a prioritized refactor task |
| Constitution exists but is not actively enforced | Constitution is actively used as the review baseline |

### Compared to Static Analyzers / Linters

| Static Analyzers | Architecture Guard |
| --- | --- |
| Require language-specific tooling per framework | Framework-agnostic, works across any stack |
| Check syntax and patterns at the code level | Checks architecture at the design level |
| Block the build | Non-blocking by default |
| Can't understand your project's custom rules | Reviews against YOUR Constitution |
| Require installation and configuration per project | Prompt-based, zero runtime dependencies |

## When To Use It

**Use it when:**

- Your project has **2+ modules** with boundaries that should be respected
- You're using **AI-assisted development** and the AI keeps introducing inconsistencies
- Your team has **more than one person** making implementation decisions
- You've established **patterns** (response shapes, service layers, data access abstractions) that should be followed consistently
- Your codebase is growing and you're seeing **repeated drift** (every new feature invents a slightly different approach)
- You want architectural debt to be **visible and prioritized** rather than hidden

**Best fit:**

- Modular monoliths
- Microservices
- Full-stack applications with shared contracts between API and UI
- Projects scaling beyond one developer
- Codebases where consistency matters more than framework purity

## When NOT To Use It

**Don't use it for:**

- **Solo projects under 3 modules** — the overhead of maintaining a Constitution isn't worth it yet
- **Scripts and one-off utilities** — there's no architecture to guard
- **Short-lived prototypes** — consistency doesn't matter if it's throwaway
- **Projects without any established patterns** — you need rules before you can check against them. Write your Constitution first.
- **Replacing profiling or benchmarking** — the optional performance mode is advisory, not measured

**The honest test:** If you can hold your entire project's architecture in your head and you're the only developer, you don't need this.

## Prerequisites

### You Need a Constitution

Architecture Guard reviews code against your **Constitution** — a Markdown document that defines your rules. Without it, the extension has nothing to validate against.

A starter template is included:

```bash
cp /path/to/spec-kit-architecture-guard/templates/CONSTITUTION.md ./CONSTITUTION.md
```

Fill in:
- Your architectural principles (e.g., "business logic must not live in controllers")
- Module boundaries and ownership
- Contract conventions (DTOs, response shapes, event schemas)
- Layering rules (what depends on what)
- Accepted deviations (intentional exceptions you don't want flagged)

You can verify your project is ready:

```bash
./scripts/check-architecture.sh /path/to/your/project
```

---

## Quick Start

1. Install the extension:
   ```text
   cd /path/to/spec-kit-project
   specify extension add architecture-guard
   ```

2. Copy and fill in `templates/CONSTITUTION.md` in your project.

3. Run the single-pass workflow:
   ```text
   /speckit.architecture-guard.architecture-workflow
   ```

4. Review the violations and refactor tasks. Apply approved changes:
   ```text
   /speckit.architecture-guard.architecture-apply
   ```

That's it. For day-to-day use, `architecture-workflow` is the only command most teams need.

---

## Commands

This extension ships five commands:

| Command | Purpose |
| --- | --- |
| `architecture-workflow` | **Start here.** Single pass: reads memory context, reviews architecture, routes security findings, produces refactor tasks. |
| `architecture-review` | Direct architecture review for a spec, plan, task list, or implementation. |
| `violation-detection` | Focused drift detection during planning or implementation. |
| `refactor-generator` | Turn detected violations into structured, prioritized refactor tasks. |
| `architecture-apply` | Write approved refactors directly into `plan.md` or `tasks.md`. |

### Where Commands Fit in the Spec Kit Lifecycle

| Spec Kit Phase | Command | Purpose |
| --- | --- | --- |
| `specify` | `architecture-review` | Check the spec for missing boundaries, contracts, and ownership |
| `plan` | `violation-detection` | Detect coupling, drift, and gaps before the plan hardens |
| `tasks` | `refactor-generator` | Convert violations into scoped, non-blocking refactor tasks |
| `implement` | `architecture-review` | Re-check implementation against the Constitution |
| Any phase | `architecture-apply` | Apply approved architectural changes to planning artifacts |
| Any phase | `architecture-workflow` | Run the full pass in one command |

### Command Modes

Commands accept an optional **mode** and **focus**:

```text
/architecture-review                    → mode=architecture, focus=general
/architecture-review performance        → mode=performance, focus=general (advisory only)
/architecture-review performance db     → mode=performance, focus=db
```

- **Architecture mode** (default): strict review, produces violations and refactor tasks
- **Performance mode**: advisory only, produces `Performance Insights` without violations

---

## How It Works with Companion Extensions

### With Memory Hub (`spec-kit-memory-hub`)

Memory Hub provides project context (past decisions, lessons, architectural conventions). Architecture Guard reads this context to make smarter reviews, but **does not require it**.

### With Security Review (`spec-kit-security-review`)

Architecture Guard routes security-first findings (auth, secrets, injection) to Security Review instead of duplicating them. It only keeps security findings when they're also **architectural boundary problems**.

### Ownership Split

| Extension | Owns |
| --- | --- |
| Architecture Guard | Boundaries, contracts, coupling, layering, consistency, refactor tasks |
| Memory Hub | Durable memory, feature synthesis, project context |
| Security Review | Authorization, secrets, injection, authentication |

---

## Framework-Agnostic Design

The core extension uses generic architectural concepts, not framework-specific names:

| Concept | Examples |
| --- | --- |
| Entry boundary | Controller, route handler, page action, resolver, component |
| Contract boundary | DTO, schema, interface, request/response object, event contract |
| Application boundary | Service, use case, handler, coordinator |
| Domain boundary | Domain model, business rule, policy |
| Data boundary | Repository, gateway, query service, client |

When the generic rules aren't specific enough for your framework, add an optional **adapter** (see `adapters/README.md`):

- `architecture-guard-laravel`
- `architecture-guard-nestjs`
- `architecture-guard-nextjs`

Adapters extend the core rules — they never replace them.

---

## Output Format

### Architecture Review

```text
Architecture Review

Constitution Alignment:
- Status: [Aligned / Partially aligned / Misaligned]
- Notes: [Why]

Violations:
- Type: [Missing Data Contract / Business Logic In Entry Boundary / etc.]
  Severity: [Critical / High / Medium / Low]
  Location: [Where in the code]
  Description: [What's wrong]
  Evidence: [What the reviewer observed]
  Principle: [Which architectural rule was violated]

Refactor Tasks:
[Refactor Task]
Title: [Actionable title]
Reason: [Why this matters architecturally]
Scope: [What to change]
Priority: [P0 / P1 / P2 / P3]
Suggested Fix: [Concrete steps]

Consistency Notes:
- Modules: [Cross-module consistency observations]
- Services: [Service layer observations]
- Handlers/Controllers: [Entry point observations]
- Data Contracts: [Contract consistency observations]

Summary:
- Overall Risk: [Critical / High / Medium / Low]
- Recommended Next Step: [What to do next]
```

### Severity and Priority Reference

| Severity | Meaning |
| --- | --- |
| `Critical` | Violates a blocking Constitution rule |
| `High` | Crosses module boundaries, hard to unwind |
| `Medium` | Local drift that may spread if repeated |
| `Low` | Minor inconsistency, clean up later |

| Priority | Meaning |
| --- | --- |
| `P0` | Must resolve before release (Constitution says it's blocking) |
| `P1` | Resolve soon to prevent architectural spread |
| `P2` | Safe to schedule as technical debt |
| `P3` | Opportunistic cleanup |

---

## Installation

### From Extension Registry

```text
cd /path/to/spec-kit-project
specify extension add architecture-guard
```

### From GitHub

```text
cd /path/to/spec-kit-project
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.0.9.zip
```

### Local Development

```text
cd /path/to/spec-kit-project
specify extension add --dev /path/to/spec-kit-architecture-guard
```

### Verification

```bash
# Check your project has the prerequisites
./scripts/check-architecture.sh /path/to/your/project

# Verify the extension itself is valid
./scripts/test-install.sh
```

---

## Project Structure

```text
spec-kit-architecture-guard/
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── extension.yml                      ← Extension manifest
├── commands/                          ← Spec Kit command definitions (self-contained)
│   ├── architecture-apply.md
│   ├── architecture-review.md
│   ├── architecture-workflow.md
│   ├── refactor-generator.md
│   └── violation-detection.md
├── adapters/
│   └── README.md                      ← Guide for creating framework adapters
├── examples/                          ← Full review examples
│   ├── generic-backend.md
│   ├── generic-frontend.md
│   └── mixed-architecture.md
├── templates/
│   └── CONSTITUTION.md                ← Starter Constitution for your project
└── scripts/
    ├── check-architecture.sh          ← Pre-flight check for target projects
    └── test-install.sh                ← Smoke tests for the extension itself
```

---

## Incremental Adoption

1. **Start small**: Review one feature with `architecture-workflow`.
2. **Build your Constitution**: Add rules as you discover patterns worth protecting.
3. **Generate, don't block**: Use refactor tasks instead of stopping implementation.
4. **Promote patterns**: When the same refactor task appears 3+ times, add it as a Constitution rule.
5. **Add an adapter** only when the generic rules aren't specific enough for your framework.

## Non-Goals

This extension does not:

- Replace security review
- Replace benchmarking or profiling
- Act as a linter or static analyzer
- Auto-update the Constitution
- Require runtime tools or framework-specific APIs
- Block implementation by default
- Enforce framework-specific conventions (use adapters for that)
