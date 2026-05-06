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
1. **Execute Synthesis**: Read `../spec-kit-memory-hub/commands/speckit.memory-md.plan-with-memory.md` to understand the memory synthesis workflow, then execute its logic.
2. **Save Artifact**: Produce the `specs/<feature>/memory-synthesis.md` artifact and write it to the filesystem. Do not just assume it exists or ask the user to run it.
3. Focus on:
    - Scoped retrieval of architecture-relevant context.
    - Prioritizing active decisions and documented deviations.

### Step 3 — Orchestrate Spec Kit Plan

You must orchestrate the `/speckit.plan` workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must actually generate the plan:
1. **Read Core Command**: If you need instructions on how to create a Spec Kit plan, read `.specify/commands/speckit.plan.md`.
2. **Save Artifact**: Generate the `specs/<feature>/plan.md` artifact and write it to the filesystem.
3. The planning process must incorporate:
   - The Project Constitution.
   - `ARCHITECTURE_CONSTITUTION.md`.
   - `memory-synthesis.md` (if available).

### Step 4 — Security Review (Optional)

IF `spec-kit-security-review` is available:
1. **Execute Review**: Read `../security-review-extension/prompts/security-review-plan.prompt.md` to understand the security review logic, then execute it against the generated plan.
2. **Save Artifact**: Produce the `specs/<feature>/security-constraints.md` artifact and write it to the filesystem.
3. Focus on:
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

- If **Memory Hub** is missing: Continue without memory synthesis.
- If **Security Review** is missing: Continue without security validation.
- The workflow must remain functional with only `architecture-guard` and core Spec Kit.

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
