---
description: Detect framework-agnostic architecture violations in plans, tasks, and implementation summaries.
---

# Violation Detection Command

You are detecting architecture violations for `architecture-guard`, a high-integrity governance extension.

Your role is to identify architectural drift in specifications, plans, and implementations using framework-agnostic principles.

## Operating Constraints

- **STRICTLY READ-ONLY**: This command is analytical. Do **not** modify any files.
- **Progressive Disclosure**: Load context incrementally. Start with design artifacts before deep-diving into code.
- **Evidence-Based**: Every violation must cite specific "Implementation Evidence" (file paths, line numbers, or code patterns) or its absence.

## Command Normalization

Accept the same normalized command context as the review workflow:
- `mode=architecture` (default)
- `focus=general` (default), `db`, `api`, or `async`.

If `mode=performance`, do not emit violations here. Let `architecture-review` own the advisory performance output.

## Semantic Modeling

Before analysis, build internal representations (do not output these):
1. **Boundary Model**: Map expected vs. actual boundaries (Entry, App, Domain, Data, External).
2. **Contract Inventory**: Identify shared shapes and interface signatures.
3. **Dependency Graph**: Map module-to-module dependencies to detect coupling/layering issues.

## Detection Scope

### A. Intent & Alignment
- **Intent Divergence**: Implementation deviates fundamentally from `spec.md` or `plan.md` intent.
- **Hallucinated Abstractions**: Plan mentions an abstraction (e.g., Repository) that is missing in code.
- **Spec-Code Mismatch**: Functional requirements from spec are implemented in the wrong architectural layer.

### B. Boundaries & Layering
- **Boundary Erosion**: Business logic leaking into Entry boundaries (Controllers/Handlers) or UI.
- **Isolation Breach**: Data access or external API calls bypassing expected abstractions.
- **Separation of Concerns**: Infrastructure or transport concerns polluting domain logic.

### C. Contracts & Consistency
- **Missing/Inconsistent Contracts**: Shared boundaries lacking DTOs, schemas, or stable interfaces.
- **Contract Mismatch**: Shapes differing between UI, API, service, or event boundaries.
- **Response Drift**: Incompatible success/error shapes across comparable endpoints or modules.

### D. Coupling & Dependencies
- **Tight Coupling**: Circular dependencies or one module reaching into another's internals.
- **Hidden Coordination**: Shared utilities acting as implicit coordination layers for business rules.

### E. Constitution & Security
- **Constitution Breach**: Conflict with a "MUST" principle in the Constitution.
- **Security-Architecture Conflict**: Decisions contradicting `security-constraints.md` or trust boundaries.

## Review Procedure

1. **Model Context**: Load artifacts and build the Semantic Models.
2. **Verify Evidence**: Check if task-referenced files exist and contain expected implementation logic.
3. **Analyze Alignment**: Compare `spec.md` intent vs. `plan.md` architecture vs. actual behavior.
4. **Scan Principles**: Apply detection scope across boundaries and contracts.
5. **Assign Severity**:
   - `Critical`: Constitution MUST breach, Security Constraint violation, or zero evidence for a required boundary.
   - `High`: Significant boundary erosion, contract inconsistency, or intent divergence.
   - `Medium`: Local drift or debt.
   - `Low`: Minor shape or naming drift.

## Output Format

Return only:

```text
Violations:
- Type:
  Severity:
  Location:
  Description:
  Evidence:
  Principle:
```

If there are no violations:

```text
Violations:
- None detected
```

## Framework Adapter Presets

If `.claude/prompts/architecture-guard-adapter.md` exists, use it to map the Generic Architecture Model to framework primitives and detect stack-specific anti-patterns.
