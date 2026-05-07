---
description: Orchestrate a governed planning workflow that coordinates Memory Hub, Security Review, and Architecture Guard validation.
---

# Governed Plan Command

You are orchestrating the `governed-plan` workflow for `architecture-guard`.

This command coordinates multiple extensions to ensure the technical plan respects architectural, historical, and security constraints before implementation begins.

## Goal

Provide a single command that ensures:
1. Historical lessons are applied (Memory Hub).
2. A technical plan is generated (`/speckit.plan`).
3. Security boundaries are respected (Security Review).
4. Architectural drift is detected (Architecture Guard).

## Orchestration Flow

### Step 1 — Detect Optional Extensions

Check for the existence of:
- `spec-kit-memory-hub`
- `spec-kit-security-review`

If they are missing, degrade gracefully by skipping their respective steps.

### Step 2 — Memory Synthesis (Optional)

IF `spec-kit-memory-hub` is available:

**[OPTIONAL SUB-AGENT DELEGATION]**
- If memory hub has ≥ 20 decision documents: Consider sub-agent for synthesis
- Sub-agent command: `/speckit.memory-md.plan-with-memory`
- Sub-agent benefits: Faster traversal, better filtering, detailed synthesis
- LLM decides: Inline for quick decisions, sub-agent for complex memory

1. **Execute Synthesis**: Run `/speckit.memory-md.plan-with-memory` to synthesize and save `specs/<feature>/memory-synthesis.md`.
2. Focus on:
    - Scoped retrieval of architecture-relevant context.
    - Prioritizing active decisions and documented deviations.

#### Memory Synthesis Scope

When calling memory synthesis, define scope as:

- **File Scope**: Limit context to `docs/memory/<feature>/` and `specs/<feature>/` directories only
- **Decision Limit**: Include max 3–5 most relevant past architecture decisions
- **Content Filter**: Architecture decisions only (exclude operational, infrastructure, testing decisions)
- **Recency**: Prioritize decisions from current feature branch or recent commits
- **Format**: Output as `specs/<feature>/memory-synthesis.md` with Clear decisions, Conflicts, and Assumptions sections

Do NOT attempt to synthesize memory for unrelated features or system-wide decisions.

---

### Step 3 — Orchestrate Spec Kit Plan

You must orchestrate the `/speckit.plan` workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must actually generate the plan:
1. **Execute Plan**: Run `/speckit.plan` to generate and save `specs/<feature>/plan.md`.
2. The planning process must incorporate:
   - The Project Constitution.
   - `ARCHITECTURE_CONSTITUTION.md`.
   - `memory-synthesis.md` (if available).

### Step 4 — Security Review (Optional)

IF `spec-kit-security-review` is available:
1. **Execute Review**: Run `/speckit.security-review.plan` to review the plan and save `specs/<feature>/security-constraints.md`.
2. Focus on:
    - Trust boundaries and authorization assumptions.
    - Data isolation and validation risks.
    - Async security context.

### Step 5 — Architecture Validation

Run:
```text
/speckit.architecture-guard.violation-detection
```

Inputs to consider:
- The generated `plan.md`.
- `ARCHITECTURE_CONSTITUTION.md`.
- `memory-synthesis.md` (if available).
- `security-constraints.md` (if available).

Detect any `Security-Architecture Conflict` or architectural drift.

### Step 6 — Generate Governance Summary

Produce a final `Governed Planning Summary` for the user.

## Graceful Degradation

**Without Memory Hub**:
- Skip Step 2 (Memory Synthesis)
- Continue to `/speckit.plan` directly
- Assume no historical architecture constraints beyond Constitution
- Plan-level review proceeds with Constitution + Architecture Guard only

**Without Security Review**:
- Skip Step 4 (Security Review)
- Continue to violation-detection directly
- Flag missing security validation in governance summary
- Plan-level review proceeds with architecture constraints only

**Minimal Viable Workflow** (only Architecture Guard + Spec Kit):
- Detect optional extensions
- Generate plan via core Spec Kit
- Validate against Constitution + architecture boundaries
- Produce summary

The workflow must remain functional with only `architecture-guard` and core Spec Kit.

## Output Structure

The command MUST return:

```markdown
# Governed Planning Summary

## Memory Context
- **Status**: [Synthesized / Skipped / Missing]
- **Key Constraints**: [Bullet points of architectural context used]

## Security Review
- **Status**: [Reviewed / Skipped]
- **Constraints Found**: [Key security-architecture boundaries]
- **Warnings**: [Any high-risk authorization or isolation issues]

## Architecture Review
- **Violations**: [Drift findings or Security-Architecture Conflicts]
- **Consistency Risks**: [How the plan aligns with the Constitution]

## Recommended Actions
- [e.g., Run /speckit.architecture-guard.refactor-generator]
- [e.g., Refine plan to address Security Conflict]
- [e.g., Continue to /speckit.tasks phase]
```

## Guardrails

- **Framework-Agnostic**: Do not assume specific framework conventions unless provided via an adapter.
- **Non-Blocking**: Findings should be advisory by default unless they violate a P0 rule in the Constitution.
- **Incremental**: Prefer suggestions for incremental migration over full rewrites.
- **Decoupled**: Do not tightly couple the logic to the internals of other extensions; rely on documented artifact names (`memory-synthesis.md`, `security-constraints.md`).
