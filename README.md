# 🛡️ Architecture Guard

> Continuous architecture governance for AI-assisted development.

[![Version](https://img.shields.io/badge/version-1.8.14-22c55e)](extension.yml)
[![Spec Kit](https://img.shields.io/badge/Spec%20Kit-compatible-2563eb)](https://spec-kit.dev)
[![Non-blocking](https://img.shields.io/badge/style-non--blocking-10b981)](https://spec-kit.dev)
[![Orchestration](https://img.shields.io/badge/role-governance--orchestrator-blue)](https://spec-kit.dev)

**Architecture Guard** is a repository-native governance layer for Spec Kit that helps AI agents follow the architecture rules you already defined. It keeps architecture review visible during delivery instead of waiting until code review.

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

## Quick Start in 3 Steps

### 1. Install the Extension

**From the Registry (Recommended):**
```text
specify extension add architecture-guard
```

**From a Release Artifact (ZIP):**
```text
specify extension add architecture-guard --from https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.8.14.zip
```

**From a Local Developer Artifact:**
```text
specify extension add architecture-guard --dev /path/to/spec-kit-architecture-guard
```

### 2. Initialize Your Constitutions

```text
/speckit.architecture-guard.init
```

### 3. Run an Architecture Review

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
| **`/speckit.architecture-guard.init`** | At project setup or when standards change | Creates or refines governance and architecture constitutions. |
| **`/speckit.architecture-guard.architecture-workflow`** | For an end-to-end review | Reviews specs, plans, tasks, and implementations for drift and refactors. |
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
    └── release-notes.md         ← Change history and workflow updates
```

### Direct Links

- [Beginner Guide](docs/beginner-guide.md) - Plain-language overview for new users
- [Architecture Overview](docs/architecture-overview.md) - Problem statement, value, and how the tool behaves
- [Governance Model](docs/governance-model.md) - Layered constitutions and delegation behavior
- [Workflows](docs/workflows.md) - Governed planning, tasks, implementation, and companion extension flows
- [Reference Manual](docs/reference-manual.md) - Install, configure, validate, and command details
- [Release Notes](docs/release-notes.md) - Recent workflow and README updates

---

## Design Philosophy

- **Non-blocking by default**: violations become refactor tasks unless a rule is explicitly marked blocking
- **Reviewable in Git**: the rules live in markdown files, not hidden state
- **Architecture first**: the extension focuses on boundaries, ownership, and drift
- **Companion-aware**: it can orchestrate other Spec Kit tools without depending on them
