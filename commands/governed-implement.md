---
description: Run implementation with memory context, then review the produced implementation against security and architecture constraints.
---

# Governed Implement Command

You are orchestrating the `governed-implement` workflow for `architecture-guard`.

This command coordinates implementation and post-implementation review to ensure the output respects architectural, historical, and security constraints.

## Goal

Provide a single command that ensures:
1. Implementation is historical-context aware (Memory Hub).
2. Implementation is performed (`/speckit.implement`).
3. The output is reviewed for security vulnerabilities (Security Review).
4. The output is reviewed for architectural drift (Architecture Guard).

## Orchestration Flow

### Step 1 — Detect Optional Extensions

Check for the existence of:
- `spec-kit-memory-hub`
- `spec-kit-security-review`

If they are missing, degrade gracefully by skipping their respective steps.

### Step 2 — Memory Synthesis

IF `spec-kit-memory-hub` is available:
1. **Execute Synthesis**: Run `/speckit.memory-md.plan-with-memory` to synthesize and refresh `specs/<feature>/memory-synthesis.md`.
2. For implementation, prioritize:
    - Accepted architecture rules and task scope.
    - Known deviations and prior implementation pitfalls.
    - Security constraints and migration rules.

#### Memory Synthesis Scope

When calling memory synthesis, define scope as:

- **File Scope**: Limit context to `docs/memory/<feature>/` and `specs/<feature>/` directories only
- **Decision Limit**: Include max 3–5 most relevant past architecture decisions
- **Content Filter**: Architecture decisions only (exclude operational, infrastructure, testing decisions)
- **Recency**: Prioritize decisions from current feature branch or recent commits
- **Format**: Output as `specs/<feature>/memory-synthesis.md` with Clear decisions, Conflicts, and Assumptions sections

Do NOT attempt to synthesize memory for unrelated features or system-wide decisions.

---

### Step 3 — Orchestrate Spec Kit Implement

You must orchestrate the `/speckit.implement` (core implementation) workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must perform the implementation by following the `tasks.md` breakdown:
1. **Execute Tasks**: Sequentially or in parallel (as marked) execute the tasks defined in `specs/<feature>/tasks.md`.
2. **Write Code**: Perform the actual coding work (writing files, running tests) required by the tasks.
3. **Sync the tasks**: You MUST update `specs/<feature>/tasks.md` to mark completed tasks with `[x]`, check them off, and add any new subtasks discovered during implementation.
4. The implementation MUST follow:
   - Current tasks and the Project Constitution.
   - `ARCHITECTURE_CONSTITUTION.md`.
   - `security-constraints.md` (if available).
   - Architecture migration plan (if available).

NOTE: The core Spec Kit command is `speckit.implement`. Do not use `speckit.implementation` as it is not a registered command.

### Step 4 — Security Review on Implementation

IF `spec-kit-security-review` is available:
1. **Execute Review**: Run `/speckit.security-review.branch` to review the produced implementation against security vulnerabilities.
2. Check for: authorization bypass, missing validation, secret leakage, injection risk, and insecure data exposure.
3. If security findings are architecture-relevant, classify them as `Security-Architecture Conflict` for the architecture review.

### Step 5 — Architecture Review on Implementation

Run:
```text
/speckit.architecture-guard.architecture-review
```

Review implementation against:
- `ARCHITECTURE_CONSTITUTION.md`.
- Plan, tasks, and `security-constraints.md`.
- Accepted deviations and `memory-synthesis.md`.

### Step 5.5 — Blocking Decision Tree

**Critical Decision Point**: Evaluate architecture findings for blocking issues.

```
IF Architecture Review finds CRITICAL or HIGH violations:
  IF Constitution marks violation as P0 (blocking):
    STOP implementation
    Surface violations in report
    Ask user: "Critical architecture violation detected. Proceed? (y/n)"
    IF user says no:
      Return early with architecture remediation tasks
  ELSE (violation is HIGH but not Constitution P0):
    Continue with warning
    Create non-blocking refactor tasks
    Flag for post-merge remediation
ELSE (no critical violations):
  Continue to Step 6
```

**Rationale**: This ensures architectural integrity while preserving delivery momentum for non-blocking issues.

### Step 6 — Generate Refactor Tasks

IF architecture violations exist:
1. Run `/speckit.architecture-guard.refactor-generator`.
2. Generate non-blocking refactor, migration, or correction tasks.
3. Skip performance refactors unless explicitly requested.

### Step 7 — Implementation Governance Summary

Produce a final `Governed Implementation Summary`.

## Graceful Degradation

**Without Memory Hub**:
- Skip Step 2 (Memory Synthesis)
- Continue to `/speckit.implement` directly
- Assume no historical implementation constraints beyond Constitution

**Without Security Review**:
- Skip Step 4 (Security Review on Implementation)
- Continue to architecture review directly
- Flag missing security implementation review in summary

**Critical Architecture Violations Found**:
- If Constitution marks as P0 (blocking):
  - STOP implementation workflow
  - Surface violations immediately
  - Return early with remediation guidance
- If HIGH but not P0:
  - Continue with warning
  - Create non-blocking refactor tasks
  - Flag for post-merge remediation

**Minimal Viable Workflow** (only Architecture Guard + Spec Kit):
- Execute implementation via core Spec Kit
- Run architecture review on output
- Generate non-blocking refactor tasks
- Produce summary

## Output Structure

The command MUST return:

```markdown
# Governed Implementation Summary

## Memory Context
- **Status**: [Refreshed / Skipped / Missing]
- **Relevant Decisions**: [Durable lessons applied during implementation]

## Security Review
- **Findings**: [List of security vulnerabilities found]
- **Constraints**: [Trust boundaries validated]
- **Blocking Concerns**: [Any P0 security risks]

## Architecture Review
- **Violations**: [Drift findings or Security-Architecture Conflicts]
- **Refactor Tasks**: [Suggested corrections]
- **Constitution Update Proposals**: [Proposed updates to ARCHITECTURE_CONSTITUTION.md]

## Implementation Status
- [Ready to merge / Needs security fix / Needs architecture refactor / Needs constitution update]

## Recommended Next Step
- [e.g., Merge changes]
- [e.g., Revise implementation to address Security Conflict]
- [e.g., Run /speckit.architecture-guard.architecture-apply]
```

## Security + Architecture Conflict Handling

If Security Review finds an issue affecting architecture, classify it as a `Security-Architecture Conflict`.
Example:
- Violation: Pricing decision in client UI.
- Security Constraint: Pricing authority must remain server-side.
- Suggested Fix: Move pricing calculation to backend service.

## Architecture Evolution Handling

If implementation repeatedly violates a standard because the standard is outdated, generate a `Constitution Update Proposal` targeting `ARCHITECTURE_CONSTITUTION.md`.

## Guardrails

- **Modular**: Do not mix security findings into a generic architecture list.
- **Framework-Agnostic**: Maintain boundary concepts (Entry, Domain, Data).
- **Non-Blocking**: Adhere to the non-blocking philosophy for architecture findings.
