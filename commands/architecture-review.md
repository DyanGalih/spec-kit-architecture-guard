---
description: Perform a framework-agnostic architecture review validating implementation against spec.md, plan.md, tasks.md, and the governance and architecture constitutions.
scripts:
  sh: ../../scripts/bash/detect-changed-files.sh
  ps: ../../scripts/powershell/detect-changed-files.ps1
---

# Architecture Review Command

You are running `architecture-guard`, a framework-agnostic architecture review extension designed for high-integrity governance.
When Memory Hub is available, treat `memory-synthesis.md` as the first context source, and keep any token-savings banner visible if the surrounding workflow emits one.
If Memory Hub is available, use `/speckit.memory-md.prepare-context` or the MCP tools exposed by `spec-kit-memory-hub`; do not shell out to `npx memory-hub` directly.

## Operating Constraints

- **STRICTLY READ-ONLY**: This command is analytical. Do **not** modify any files. Output a structured report and non-blocking refactor tasks.
- **Progressive Disclosure**: Load context incrementally. Start with manifests and design artifacts before deep-diving into implementation code.
- **Evidence-Based**: Every violation must cite specific "Implementation Evidence" (file paths, line numbers, or code patterns) or its absence.

---

## Sub-Agent Delegation (Hybrid Model)

Throughout this command, complex analysis steps offer **optional sub-agent delegation**:

**Syntax: `[OPTIONAL SUB-AGENT DELEGATION]`**

When you see this marker in a step:
- LLM assesses complexity: file count, lines of code, decision count, etc.
- LLM decides: Handle inline (fast path) OR delegate to sub-agent (thorough path)
- Inline preferred: Simple codebases, small changes, quick turnaround
- Sub-agent preferred: Large codebases, complex analysis, refactors, deep synthesis

**Decision criteria:**
- Inline: < 50 files AND < 10,000 lines
- Sub-agent: ≥ 50 files OR ≥ 10,000 lines OR > 20 memory documents
- LLM override: Explicit `--inline` or `--delegate` flags override auto-detection

**Sub-agents available when provided by the host environment or project:**
- `/speckit.memory-md.plan-with-memory` — Memory synthesis and filtering
- Custom project commands such as `/analyze-sonar-violations` for SonarLint scanning

This pattern enables flexibility: fast execution for typical PRs, powerful execution for large refactors.

---

## Framework-Agnostic vs Framework-Aware Review

**Framework-Agnostic Foundation** (always applied):
- Universal boundary concepts (Entry, App, Domain, Data, External)
- Core governance principles apply to any architecture
- Violations are framework-independent

**Framework-Aware Annotations** (if preset installed):
- If project used preset during init (e.g., Laravel, Django, NestJS):
  - Review vocabulary becomes framework-specific
  - Patterns are mapped to framework conventions
  - Guidance references framework-native concepts
  - BUT underlying violations remain identical

**Coexistence Model**:
- Review always starts framework-agnostic
- If preset detected in `.specify/presets/` or the Constitution: Enhance with framework vocabulary
- Violations list remains the same; explanation becomes framework-native
- Example: "Entry boundary contamination" (agnostic) → "Controller mixing HTTP and business logic" (Laravel-aware)

---

## Determine Review Scope

1. **Normalize Arguments**: Parse "$ARGUMENTS" to identify the `mode` (`architecture` or `performance`) and `focus` aspects (`general`, `db`, `api`, or `async`).
2. **Identify Changed Files**:
   - If the user provided a file list or explicit instructions, follow them.
   - Otherwise, you **MUST** execute the `{SCRIPT}` with `--json` to detect changed files since the merge-base or in the working directory.
   - Use the `changed_files` list as the primary review set.

## Input & Context Loading

Review any available artifacts from these common locations. **IMPORTANT**: You MUST read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore` and may be excluded from default context:

1. **Governance & Security Constitution**:
    - `.specify/memory/constitution.md`
    - `.specify/memory/security_constitution.md`

2. **Architecture Constitution**:
    - `.specify/memory/architecture_constitution.md`

3. **Memory Hub Optimizer (Recommended)**:

    #### Optimizer-Aware Flow
    When `.specify/extensions/memory-md/config.yml` has `optimizer.enabled: true`:

    1. **Prepare Context**: Execute `/speckit.memory-md.prepare-context --feature specs/<feature> --query "architecture constraints boundaries dependencies coupling abstractions"`.
    2. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` to identify the "Why" behind the current design.

    #### Markdown-Only Flow
    When the optimizer is disabled or unavailable, you **MUST** read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:

    - `docs/memory/INDEX.md` (Read this first to identify relevant source sections)
    - `docs/memory/` for durable repository memory (Read only the sections identified in the index)
    - `.specify/memory/` for project-wide architecture rules and standards
    - `specs/<feature>/memory.md` for active feature memory
    - `specs/<feature>/memory-synthesis.md` for the concise working summary
    - `specs/<feature>/security-constraints.md` for security boundaries
    - `.github/copilot-instructions.md` for repo-scoped Copilot guidance

4. **Implementation Context**:
    - `spec.md`, `plan.md`, `tasks.md`, `data-model.md`
    - The detected `changed_files` and their respective directories.

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
6. **Security & Governance Cross-Check**:
   - If `security-constraints.md` or `security_constitution.md` is breached, log it as a critical violation.
   - Cross-reference architecture decisions with security trust boundaries.
7. **Performance Scan (if mode=performance)**: Skip violations; focus on optimizations.
7b. **Code Quality Scan (SonarLint)**: If `mode=architecture`, optionally scan for coupling/complexity violations.
8. **Generate Refactors**: Produce structured tasks for each confirmed violation.

---

## Code Quality Scan (SonarLint) — Optional Step 7b

This step runs code quality checks using bundled SonarLint rules. It is **optional** and complements architecture violations.
The rules bundle is repository-native and IDE-agnostic, so it works the same in VS Code, Cursor, JetBrains, or CLI-only workflows.
When the extension is installed, load the bundle from `.specify/extensions/architecture-guard/.github/sonar-rules/sonarlint-rules.json`.

### Activation

- Run only if `mode=architecture` (not for performance mode)
- Skip if user explicitly disables with `--no-sonarlint`
- Skip if the repository does not contain a SonarLint rules bundle or the bundle is empty
- If skipped, continue the rest of the architecture review and note that the optional SonarLint scan was unavailable

### Scope-Based Delegation (Hybrid Model)

**Inline Execution** (default for small codebases):
- Changed files < 50 files
- Total lines < 10,000
- Process directly, no sub-agent

**[OPTIONAL SUB-AGENT DELEGATION]**:
- If changed files ≥ 50 OR total lines ≥ 10,000:
  - Consider delegating to sub-agent for parallel rule scanning
  - Suggested sub-agent: Custom `/analyze-sonar-violations` if the project defines it; otherwise use inline scanning
  - Sub-agent benefits: Parallelized rule evaluation, detailed categorization
  - LLM decides: Inline for fast path, sub-agent for thorough path

### Procedure

**If inline**:
1. **Load Rules**: Read the installed extension bundle at `.specify/extensions/architecture-guard/.github/sonar-rules/sonarlint-rules.json` first; if running from the extension source checkout, use `.github/sonar-rules/sonarlint-rules.json`
2. **Scan Changed Files**: Simulate or invoke SonarLint logic on `changed_files` list
3. **Filter Results**: Keep only CRITICAL/HIGH severity findings related to complexity, coupling, structure
4. **Map to Boundaries**: Correlate findings with architecture boundaries (Entry/App/Domain/Data/External)
5. **Deduplicate**: If a violation is already in architecture violations list, suppress from SonarLint output
6. **Categorize**: Group findings by rule category (Brain Overload, Dependency Coupling, Structure Drift, Performance Anti-patterns)

**If delegated to sub-agent**:
- Sub-agent receives rules JSON + changed files list
- Returns structured violations (organized by category and severity)
- Main agent integrates into architecture report

### Interpretation Guide

| SonarLint Category | Architecture Signal |
|---|---|
| Brain Overload (high complexity) | Hidden boundaries; function does too much |
| Dependency Coupling (tight dependencies) | Cross-module leakage; missing abstraction |
| Structure Drift (inconsistent patterns) | Boundary erosion; inconsistent contracts |
| Performance Anti-patterns | Possible architectural misuse (e.g., N+1 queries from wrong layer) |

### Output Integration

Add a new section in the report (see Output Format below):

```markdown
### Code Quality Findings (SonarLint)

Findings that correlate with architecture concerns:

| Rule | Severity | File | Issue |
|---|---|---|---|
| [Rule Key] | [HIGH/CRITICAL] | [File:Line] | [Issue summary + recommended boundary fix] |
```

**Note**: Pure style violations (formatting, naming conventions) are filtered out.

---

Every violation MUST cite evidence or explicitly note its absence. Evidence can be:

- **Specific**: Concrete code reference like `src/checkout/route.js:45-67 contains pricing logic that should be in service layer`
- **Pattern**: Behavioral observation like `All 5 user endpoints return different response shapes instead of standard contract`
- **Absence**: Missing implementation like `Task references Repository pattern but no repo/ folder exists`

**Absence Evidence** is acceptable for CRITICAL violations only. Example:
- "Constitution requires data access abstraction but `repositories/` folder does not exist"

For all other violations, cite specific code locations, line numbers, or patterns. Vague claims like "business logic is leaking" without specific evidence are insufficient.

---

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
| V1 | Constitution | CRITICAL | `.specify/memory/architecture_constitution.md` | Violation of [Principle Name] | [Evidence from code/plan] |

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

(Only if `mode=architecture` and SonarLint findings detected)
### Code Quality Findings (SonarLint)

Findings that correlate with architecture concerns:

| Rule | Severity | File | Issue | Architecture Signal |
|:---|:---|:---|:---|:---|
| `brain-overload::...` | HIGH | src/service/checkout.ts:45 | Function has 8 parameters | Hidden boundary: pricing logic should be in dedicated module |

**Note**: Pure style violations (formatting, naming) are filtered out. Only findings related to complexity, coupling, and structure are included.

---

(Only if `mode=architecture` and Constitution drift is cross-cutting)
### Constitution Update Proposal
- **Current Rule**: 
- **Proposed Change**: 
- **Rationale**: 

---

### Action Plan
1. **Critical Fixes**: Address Constitution and Security violations first.
2. **Architecture Alignment**: Resolve boundary erosion and contract mismatches.
3. **Code Quality**: Address SonarLint findings that map to architectural concerns (if any).
4. **Durable Memory Preservation (Mandatory Check)**: If new architectural patterns, decisions, or repeatable lessons were identified, you **MUST** execute `/speckit.memory-md.capture` after providing the report. Use the formal capture flow to propose entries and wait for user approval.
5. **Next Step**: [e.g. Run /speckit.architecture-guard.architecture-apply]
6. **Remediation**: [Concrete remediation direction for the top issues, or "None needed"]

## Framework Preset Guidance

If framework preset guidance exists, it is **mandatory** to use it to map generic principles to framework primitives and detect stack-specific anti-patterns.

Preset path:
- `.specify/presets/architecture-guard-preset.md`
