# Reference Manual

This document collects setup, commands, installation, and validation details.

## Prerequisites

Architecture Guard depends on architecture standards.

Without architecture rules, the extension has nothing meaningful to validate against.

## Validate Your Setup

Before running governed workflows, verify prerequisites with the included setup validator:

```bash
# Bash
./scripts/validate-setup.sh
```

```powershell
# PowerShell
.\scripts\powershell\validate-setup.ps1
```

The validator checks constitution files, Spec Kit structure, optional extensions, optimizer status, and source directories. It exits non-zero when blocking errors are present, which makes it safe to use in CI.

## Initialize Your Constitutions

Run:

```text
/speckit.architecture-guard.init
```

This command can:

- initialize constitutions
- refine existing constitutions
- split governance and architecture rules
- detect duplicated architecture standards
- generate architecture enforcement rules

It may generate:

```text
.specify/memory/constitution.md
.specify/memory/architecture_constitution.md
```

## What the Initializer Defines

### Governance Standards

Examples:

- testing expectations
- documentation standards
- review policies
- engineering philosophy

### Architecture Standards

Examples:

- business logic placement
- validation boundaries
- response contracts
- module ownership
- async boundaries
- layering rules

## Architecture Evolution Support

The initializer also supports:

- constitution refinement
- architecture evolution
- migration planning
- architecture standard extraction

By using explicit markdown files, extensions remain decoupled, and all constraints and decisions are fully reviewable in Git.

## Quick Start

### 1. Install

```text
specify extension add architecture-guard
```

### 2. Initialize Constitutions

```text
/speckit.architecture-guard.init
```

This creates or updates:

- `.specify/memory/constitution.md` - governance and engineering standards
- `.specify/memory/architecture_constitution.md` - architecture rules and boundaries
- `.specify/memory/security_constitution.md` - security standards

### 3. Run Architecture Workflow

```text
/speckit.architecture-guard.architecture-workflow
```

Outputs:

- architecture alignment status
- detected violations with severity and priority
- suggested refactor tasks
- evolution proposals

### 4. Review Violations and Apply Fixes

```text
/speckit.architecture-guard.architecture-apply
```

This injects refactor tasks into `plan.md` and `tasks.md` so the AI has explicit guidance to fix architectural debt while implementing features.

## Commands

| Command | Phase | Output | When To Use |
| --- | --- | --- | --- |
| `init` | Setup | `.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, `.specify/memory/security_constitution.md` | Once at project start; rerun to refine standards |
| `architecture-workflow` | General Review | Violations, severity and priority, refactor tasks, evolution proposals | Entry point for end-to-end review; good for dashboards |
| `architecture-review` | Validation | Cached-context alignment status, boundary issues, contract drift | After `/specify`, `/plan`, or `/implement` |
| `violation-detection` | Detection | Drift summary, boundary violations, module coupling | Focus on specific architecture problems |
| `refactor-generator` | Planning | Refactor task generation | After review; convert violations to non-blocking refactor tasks |
| `architecture-apply` | Implementation | After refactor decisions | Inject refactor tasks into `tasks.md` and `plan.md` using the approved review context |
| `architecture-verify` | Verification | Task fulfillment report, gap analysis | Final gate after implementation to ensure all tasks are delivered, with cached memory context if available |

## Optimizer-Aware Memory Flow

Architecture Guard integrates with `flash-mem` as the runtime SQLite-backed optimizer to provide high-performance, token-efficient reviews. The legacy `memory-hub` name is reference-only and deprecated.

### Enabling the Optimizer

In your local Spec-Kit project, ensure the optimizer is enabled:

```yaml
# .specify/extensions/memory-md/config.yml
optimizer:
  enabled: true
```

### Benefits

- targeted retrieval: only reads architectural decisions relevant to the current feature
- self-learning: reviews trigger the durable-memory capture alias, and the formal capture flow proposes entries and requests user approval
- lower latency: reduces context window bloat by avoiding massive markdown file reads

| `governed-plan` | Orchestration | Plan with `flash-mem` synthesis first + security + architecture | Use when `flash-mem` and Security Review are installed |
| `governed-tasks` | Orchestration | Tasks with cached memory context + security + architecture refactors | Use when companion extensions are installed |
| `governed-implement` | Orchestration | Implementation validation with cached memory governance context | Use for end-to-end implementation with governance |

> Most projects use `architecture-workflow` or `architecture-review` directly. Orchestrator commands (`governed-*`) are advanced and optional when companion extensions are available.

> `architecture-apply` targets `plan.md` and `tasks.md`. If architectural issues are found in the specification stage, refine the specification before generating a technical plan. When `flash-mem` is available, use the cached synthesis and approved review output before writing back.

## Installation

### From Registry

```text
specify extension add architecture-guard
```

### From a Release Artifact (ZIP)

```text
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.8.11.zip
```

### Global Preset Usage

If you manage multiple projects using the same framework (e.g., Laravel), you can create a global preset and link it to Architecture Guard when initializing a new project.

**Example: Global Laravel Preset**

1. Create your preset somewhere on your system (e.g., `~/.specify/presets/laravel-architecture.md`).
2. Add the Architecture Guard extension and apply the preset URL:

```bash
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.8.11.zip
```

### From a Local Developer Artifact

```text
specify extension add architecture-guard --dev /path/to/spec-kit-architecture-guard
```

### From GitHub

```text
specify extension add architecture-guard --from \
  https://github.com/DyanGalih/spec-kit-architecture-guard/archive/refs/tags/v1.8.11.zip
```
