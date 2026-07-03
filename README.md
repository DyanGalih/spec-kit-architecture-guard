# 🛡️ Architecture Guard

> Continuous architecture governance for AI-assisted development.

[![Version](https://img.shields.io/badge/version-1.10.1-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Orchestration](https://img.shields.io/badge/role-governance--orchestrator-blue)](https://spec-kit.dev)

**Architecture Guard** is a repository-native governance layer for Spec Kit that helps AI agents follow the architecture rules you already defined. It keeps architecture review visible during delivery instead of waiting until code review.

---

✨ **NEW in v1.10.x: Built-in Pragmatism & Hygiene Guards!**  
You no longer need to install separate agent skills for code minimalism or repository cleanliness—Architecture Guard now has them built directly into its orchestrated workflows:
* **Ponytail Pragmatism:** Enforces the "lazy senior developer" mindset (YAGNI, minimal dependencies, one-liners) natively during implementation. *(Inspired by the [Ponytail Pragmatism Skill](https://github.com/DietrichGebert/ponytail))*
* **Repository Hygiene Guard:** Automatically detects stray `*-copy.ts` drafts, orphaned code, and debug artifacts before they hit your main branch. [Learn more →](docs/repository-hygiene.md)

---

## Core Value: Architecture Guidance Without Hidden Drift

Architecture Guard uses a layered, reviewable workflow to keep architecture decisions explicit:

| Layer | Focus | What It Prevents |
| :--- | :--- | :--- |
| **Governance** | High-level engineering rules | Loose, inconsistent project standards |
| **Architecture** | Boundaries, ownership, and contracts | Drift between modules and layers |
| **Workflow** | Reviews and refactor generation | Hidden architecture debt |

### Why Developers and Teams Use It:

- architecture decisions stop living only in people’s heads
- drift becomes visible as refactor work instead of silent debt
- smaller models get clearer rules to follow
- architecture checks happen during delivery, not only at review time
- the same ideas work across Laravel, NestJS, Next.js, Django, and more

---

## Why Use the Governed Workflows?

Instead of running the raw Spec Kit commands (`/speckit.specify`, `/speckit.plan`, `/speckit.tasks`), you should use Architecture Guard's orchestrated commands (`governed-spec`, `governed-plan`, `governed-tasks`).

Using the governed orchestrators simplifies the upper Spec Kit flow by adding automatic layers of safety:
1. **Context-Aware:** It automatically queries `flash-mem` first to inject historical architectural decisions before generating any new outputs.
2. **Unified Execution:** A single command runs the core Spec Kit generation (like `/speckit.specify` or `/speckit.tasks`), hands it off to Security Review, and then triggers the Architecture Guard.
3. **Analyst Auto-Fix Loops:** Rather than finding out your plan violates architecture at the end, the orchestrators use formal analysis (`/speckit.analyze`). If the analyst detects gaps, missing boundaries, or severities, the orchestrator automatically pauses and offers a loop to clarify and repair the artifacts instantly.
4. **Ponytail Pragmatism:** The best feature of these workflows—they enforce a "lazy senior developer" mindset. This prevents over-engineering, minimizes external dependencies, and strictly enforces YAGNI (You Aren't Gonna Need It) during specification and implementation to keep your codebase lean.

This guarantees your specifications and tasks are explicitly validated *before* writing code, and implemented as simply as possible.

---

## Quick Start

Choose the path that matches your repository state.

### Brownfield Quick Start

Use this when the repository already contains application code.

1. Install the extension

From the Spec Kit extensions registry:
```text
specify extension add architecture-guard
```

Or directly from the release artifact:
```text
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.10.1.zip
```

2. Map the existing codebase

```text
/speckit.architecture-guard.init-brownfield
```

3. Run an architecture review

```text
/speckit.architecture-guard.architecture-workflow
```

If violations appear, apply approved refactors:

```text
/speckit.architecture-guard.architecture-apply
```

### Greenfield Quick Start

Use this when the repository is greenfield or when you want to define constitutions first.

1. Install the extension

From the Spec Kit extensions registry:
```text
specify extension add architecture-guard
```

Or directly from the release artifact:
```text
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.10.1.zip
```

2. Initialize your constitutions

```text
/speckit.architecture-guard.init
```

3. Run an architecture review

```text
/speckit.architecture-guard.architecture-workflow
```

If violations appear, apply approved refactors:

```text
/speckit.architecture-guard.architecture-apply
```

---

## Command Directory

| Command | When To Use | What It Does |
| :--- | :--- | :--- |
| **`/speckit.architecture-guard.init-brownfield`** | For existing codebases | Maps the current state, boundaries, and conventions before governance work. |
| **`/speckit.architecture-guard.init`** | At project setup or when standards change | Creates or refines governance and architecture constitutions. |
| **`/speckit.architecture-guard.architecture-workflow`** | For an end-to-end review | Reviews specs, plans, tasks, and implementations for drift and refactors. |
| **`/speckit.architecture-guard.governed-spec`** | Specification Phase | Orchestrates specify and clarify with architecture and memory context validation, plus an auto-fix loop. |
| **`/speckit.architecture-guard.architecture-review`** | After `/specify`, `/plan`, or `/implement` | Checks a spec, plan, or implementation against architecture rules. |
| **`/speckit.architecture-guard.refactor-generator`** | After violations are found | Converts violations into structured refactor tasks. |
| **`/speckit.architecture-guard.architecture-apply`** | When refactors are approved | Injects approved architecture work into plans and tasks. |
| **`/speckit.architecture-guard.architecture-verify`** | Final validation step | Checks whether the final work matches the approved tasks. |

---

## Technical Documentation Map

We split the Architecture Guard manual into focused technical resources:

```
spec-kit-architecture-guard/
├── README.md                  ← Readable, high-level project summary
└── docs/
    ├── beginner-guide.md       ← Plain-language explanation and first workflow
    ├── architecture-overview.md ← Problem statement, value, and behavior
    ├── governance-model.md      ← Constitution layers and delegation model
    ├── workflows.md             ← Governed planning, task, and implementation flows
    ├── reference-manual.md      ← Setup, commands, install, and validation details
    ├── repository-hygiene.md    ← Repository Hygiene rules and configuration
    └── release-notes.md         ← Change history and workflow updates
```

### Direct Links

- [Beginner Guide](docs/beginner-guide.md) - Plain-language overview for new users
- [Architecture Overview](docs/architecture-overview.md) - Problem statement, value, and how the tool behaves
- [Governance Model](docs/governance-model.md) - Layered constitutions and delegation behavior
- [Workflows](docs/workflows.md) - Governed planning, tasks, implementation, and companion extension flows
- [Reference Manual](docs/reference-manual.md) - Install, configure, validate, and command details
- [Repository Hygiene](docs/repository-hygiene.md) - Configuration and rules for the Repository Hygiene Guard
- [Release Notes](docs/release-notes.md) - Recent workflow and README updates

---

## Design Philosophy

- **Non-blocking by default**: violations become refactor tasks unless a rule is explicitly marked blocking
- **Reviewable in Git**: the rules live in markdown files, not hidden state
- **Architecture first**: the extension focuses on boundaries, ownership, and drift
- **Companion-aware**: it can orchestrate other Spec Kit tools without depending on them
- **Ponytail Pragmatism (YAGNI)**: baked-in "lazy senior developer" mindset to actively prevent bloat and over-engineering across all phases of delivery

## Versioning Policy

This project strictly adheres to [Semantic Versioning (SemVer) 2.0.0](https://semver.org/). Version numbers follow the `MAJOR.MINOR.PATCH` format:
- **MAJOR** version when making incompatible API changes,
- **MINOR** version when adding functionality in a backward-compatible manner, and
- **PATCH** version when making backward-compatible bug fixes.

## Brownfield init

See the Quick Start above for the brownfield entrypoint.

