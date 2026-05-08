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

### Scope Filtering by Focus

**When focus=general** (default):
- Review all violation categories (A through E)
- Detect intent divergence, boundary erosion, contracts, coupling, Constitution breach

**When focus=db** (data/persistence):
- Review only data access violations
- Scope to repositories, query services, ORM usage
- Detect: missing repository pattern, isolation breach, tight coupling with persistence

**When focus=api** (API contracts):
- Review only API contract and response violations
- Scope to endpoints, DTOs, response shapes, request validation
- Detect: contract mismatch, inconsistent responses, missing validation boundaries

**When focus=async** (async boundaries):
- Review only async execution and event violations
- Scope to queues, event handlers, background jobs, async boundaries
- Detect: blocking in async, missing event contracts, isolation breaches

---

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

## Security-Architecture Conflict (Detailed)

A Security-Architecture Conflict occurs when security requirements and architecture boundaries create opposing design constraints. These must be flagged with **CRITICAL** severity and routed to both security and architecture workflows.

### Examples

**Example 1: Sensitive Data Placement**
- **Security Constraint**: "Pricing logic must remain server-side; never expose to client"
- **Architecture Finding**: "Pricing displayed in client component fetching pricing from API endpoint"
- **Conflict**: Client architecture violates server-side security boundary
- **Resolution**: Move pricing calculation to server boundary, client receives only final price

**Example 2: Secret Management**
- **Security Constraint**: "API keys stored in `.env`, never passed to build or frontend"
- **Architecture Finding**: "Environment variables passed to frontend build process"
- **Conflict**: Build architecture leaks secrets to frontend bundle
- **Resolution**: Store secrets only in backend runtime, never in build environment

**Example 3: Authorization Boundary**
- **Security Constraint**: "User can only access their own data"
- **Architecture Finding**: "Data access layer queries all users without ownership check"
- **Conflict**: Persistence layer bypasses authorization boundary
- **Resolution**: Add ownership filter to repository, move check to before data access

---

## Review Procedure

1. **Model Context**: Load artifacts and build the Semantic Models. Look for:
   - `.specify/memory/constitution.md`
   - `.specify/memory/architecture_constitution.md`
   - `.specify/memory/security_constitution.md`
   - `specs/<feature>/security-constraints.md`
   - `specs/<feature>/memory-synthesis.md`
   - `spec.md`, `plan.md`, `tasks.md`, `data-model.md`
2. **Verify Evidence**: Check if task-referenced files exist and contain expected implementation logic.
3. **Analyze Alignment**: Compare `spec.md` intent vs. `plan.md` architecture vs. actual behavior.
4. **Scan Principles**: Apply detection scope across boundaries and contracts.
5. **Security & Governance Cross-Check**: Ensure architecture decisions do not violate `security_constitution.md` or `security-constraints.md`.
6. **Assign Severity**:
   - `Critical`: Constitution MUST breach (including Security), Security Constraint violation, or zero evidence for a required boundary.
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

## Framework Preset Guidance

If framework preset guidance exists, use it to map the Generic Architecture Model to framework primitives and detect stack-specific anti-patterns.

Preset path:
- `.specify/presets/architecture-guard-preset.md`
