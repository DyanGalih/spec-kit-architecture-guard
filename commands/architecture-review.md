---
description: Perform a framework-agnostic architecture review validating implementation against spec.md, plan.md, tasks.md, and constitution.md.
scripts:
  sh: ../../scripts/bash/detect-changed-files.sh
  ps: ../../scripts/powershell/detect-changed-files.ps1
---

# Architecture Review Command

You are running `architecture-guard`, a framework-agnostic architecture review extension designed for high-integrity governance.

## Operating Constraints

- **STRICTLY READ-ONLY**: This command is analytical. Do **not** modify any files. Output a structured report and non-blocking refactor tasks.
- **Progressive Disclosure**: Load context incrementally. Start with manifests and design artifacts before deep-diving into implementation code.
- **Evidence-Based**: Every violation must cite specific "Implementation Evidence" (file paths, line numbers, or code patterns) or its absence.

## Determine Review Scope

1. **Normalize Arguments**: Parse "$ARGUMENTS" to identify the `mode` (`architecture` or `performance`) and `focus` aspects (`general`, `db`, `api`, or `async`).
2. **Identify Changed Files**:
   - If the user provided a file list or explicit instructions, follow them.
   - Otherwise, you **MUST** execute the `{SCRIPT}` with `--json` to detect changed files since the merge-base or in the working directory.
   - Use the `changed_files` list as the primary review set.

## Input & Context Loading

Review any available artifacts:
- **Constitution**: `.specify/memory/constitution.md` (Non-negotiable authority).
- **Security Constraints**: `specs/<feature>/security-constraints.md`.
- **Memory Context**: `specs/<feature>/memory-synthesis.md`.
- **Feature Design**: `spec.md`, `plan.md`, `tasks.md`, `data-model.md`.
- **Implementation**: The detected `changed_files` and their respective directories.

## Semantic Modeling

Before analysis, build internal representations (do not output these):
1. **Boundary Model**: Map the expected boundaries (Entry, Application, Domain, Data, External) vs. actual directory structure.
2. **Contract Inventory**: Identify shared data shapes, API signatures, and event structures.
3. **Task-Implementation Map**: Map `tasks.md` IDs to specific code files and check completion status.
4. **Dependency Graph**: Map module-to-module dependencies to detect coupling or layering violations.

## Review Principles

Use these core principles to detect drift:
- **Validation Boundaries**: External input must be validated before reaching core logic.
- **Contract Fidelity**: Shapes should be expressed through contracts at shared boundaries.
- **Entry Point Delegation**: Controllers/Handlers must delegate business logic to services/domain.
- **Stable Abstractions**: Modules should depend on interfaces/abstractions, not internals.
- **Isolation**: Data access, external APIs, and infrastructure must be isolated.
- **Consistency**: Comparable endpoints or modules must use compatible patterns.
- **Non-Blocking**: Identify drift without converting style preferences into hard failures.

## Detection Scope

Detect violations such as:
- **Intent Divergence**: Implementation deviates fundamentally from `spec.md` or `plan.md` intent.
- **Hallucinated Abstractions**: Plan mentions an abstraction (e.g., Repository) that is missing in code.
- **Boundary Erosion**: Business logic leaking into entry points or UI.
- **Tight Coupling**: Circular dependencies or cross-module leakage.
- **Contract Mismatch**: Mismatch between API, UI, or service shapes.
- **Constitution Breach**: Any conflict with a "MUST" principle in the Constitution.

## Review Procedure

1. **Identify Scope**: Run `{SCRIPT}` or use user-provided files.
2. **Model Context**: Load artifacts and build the Semantic Models for the identified scope.
3. **Verify Evidence**: Check if task-referenced files exist and contain expected implementation logic.
4. **Analyze Alignment**: Compare `spec.md` intent vs. `plan.md` architecture vs. implementation behavior.
5. **Scan Principles**: Apply Review Principles across the implemented boundaries.
6. **Security Cross-Check**: If `security-constraints.md` is breached, log it as a critical violation.
7. **Performance Scan (if mode=performance)**: Skip violations; focus on optimizations.
8. **Generate Refactors**: Produce structured tasks for each confirmed violation.

## Severity Guide

- **CRITICAL**: Violates Constitution MUST, breaches Security Constraint, or has zero implementation evidence for a required boundary.
- **HIGH**: Significant boundary erosion, contract inconsistency, or fundamental intent divergence.
- **MEDIUM**: Pattern drift or local inconsistency that creates technical debt.
- **LOW**: Minor naming, shape, or structure drift.

## Output Format

Return only this structure:

# Architecture Review Report

| ID | Category | Severity | Location(s) | Summary | Evidence/Rationale |
|:---|:---|:---|:---|:---|:---|
| V1 | Constitution | CRITICAL | `.specify/memory/constitution.md` | Violation of [Principle Name] | [Evidence from code/plan] |

### Task Synchronization
- **Status**: [Synced / Drifted]
- **Missing Implementations**: [Files referenced in tasks but missing/empty]
- **Pending Tasks**: [Incomplete tasks blocking architecture]

### Metrics
- **Constitution Compliance**: [e.g. 90%]
- **Boundary Integrity**: [e.g. Strong / Eroded]
- **Architectural Risk**: [LOW / MEDIUM / HIGH / CRITICAL]

### Refactor Tasks
[Refactor Task]
- **Title**: 
- **Priority**: [Based on Severity]
- **Reason**: 
- **Suggested Fix**: 

---

(Only if `mode=performance`)
### Performance Insights
- **Suggestion**: 
- **Trade-off**: 

(Only if `mode=architecture` and Constitution drift is cross-cutting)
### Constitution Update Proposal
- **Current Rule**: 
- **Proposed Change**: 
- **Rationale**: 

---
### Action Plan
1. **Critical Fixes**: Address Constitution and Security violations first.
2. **Architecture Alignment**: Resolve boundary erosion and contract mismatches.
3. **Next Step**: [e.g. Run /speckit.architecture-guard.architecture-apply]
4. **Remediation**: "Would you like me to suggest concrete remediation edits for the top issues?"

## Framework Adapter Presets

If `.claude/prompts/architecture-guard-adapter.md` exists, it is **mandatory** to use it to map generic principles to framework primitives and detect stack-specific anti-patterns.

