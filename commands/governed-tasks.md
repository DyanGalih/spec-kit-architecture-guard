---
description: Generate or validate implementation tasks with memory context, security constraints, and architecture refactor/migration awareness.
---

# Governed Tasks Command

You are orchestrating the `governed-tasks` workflow for `architecture-guard`.

This command coordinates multiple extensions to ensure the task list respects architectural, historical, and security constraints before implementation begins.
The orchestrator should be memory-first: reuse the current synthesis before reopening the full memory set, and only refresh the cache when the plan or feature scope changed.

## Goal

Provide a single command that ensures:
1. Implementation tasks are historical-context aware (Memory Hub).
2. A task list is generated or validated (`/speckit.tasks`).
3. Security requirements are represented in tasks (Security Review).
4. Architecture refactors or migrations are represented in tasks (Architecture Guard).

## Orchestration Flow

### Step 1 — Detect Optional Extensions

Check for the existence of:
- `spec-kit-memory-hub`
- `spec-kit-security-review`

**Detection Logic**:
1. Read `.specify/extensions.yml` and check the `installed` list. If an extension ID is present there, consider it available.
2. Fall back to checking for the extension directory in `.specify/extensions/` only if the YAML is missing or the list is empty.
3. If they are missing from both, degrade gracefully by skipping their respective steps.

### Step 2 — Memory Synthesis (Optional)

IF `spec-kit-memory-hub` is available:

#### Optimizer-Aware Flow
When `.specify/extensions/memory-md/config.yml` has `optimizer.enabled: true`:

1. **Prepare Context**: Execute `/speckit.memory-md.prepare-context --feature specs/<feature> --query "architecture decisions constraints boundaries <feature>"`.
2. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` to identify constraints.
3. If Memory Hub emits a token banner, keep it visible so the savings remain observable during normal task generation runs.

#### Markdown-Only Flow
If the optimizer is disabled, use the standard synthesis command:

1. **Execute Synthesis**: Run `/speckit.memory-md.plan-with-memory` to synthesize and save `specs/<feature>/memory-synthesis.md`.

**[OPTIONAL SUB-AGENT DELEGATION]**
- If memory hub has ≥ 20 decision documents: Consider sub-agent for synthesis
- Sub-agent command: `/speckit.memory-md.plan-with-memory`
- Sub-agent benefits: Faster traversal, better filtering, detailed synthesis
- LLM decides: Inline for quick decisions, sub-agent for complex memory

---

### Step 3 — Orchestrate Spec Kit Tasks

You must orchestrate the `/speckit.tasks` workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must actually generate the tasks:
1. **Execute Tasks**: Run `/speckit.tasks` to generate and save `specs/<feature>/tasks.md`.

   **If `/speckit.tasks` is not available as a registered command** (i.e., the AI agent does not recognize it as a slash command), fall back to inline task generation:
   - Read `specs/<feature>/plan.md` (and `spec.md` if present).
   - Read all applicable constitution files (`.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, `.specify/memory/security_constitution.md`).
   - Read `specs/<feature>/memory-synthesis.md` and `specs/<feature>/security-constraints.md` if available.
   - Generate `specs/<feature>/tasks.md` directly, breaking down the plan into implementation-ready tasks with checkbox format.
   - Note in the Governance Summary that `/speckit.tasks` was unavailable and task generation was performed inline.

2. The generated tasks MUST use the Project Constitution documents and feature context. **IMPORTANT**: You MUST read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:
   - `.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, and `.specify/memory/security_constitution.md`.
   - Also use `specs/<feature>/memory-synthesis.md`, `specs/<feature>/security-constraints.md` (if available).
3. Prefer compact, feature-scoped task generation over broad restatements of the full memory set.

### Step 4 — Security Review on Tasks

IF `spec-kit-security-review` is available:
1. **Execute Review**: Run `/speckit.security-review.tasks` to review the task list.
2. Check for missing tasks related to:
    - Validation, authorization, and trust boundaries.
    - Secure integration and audit/logging.
3. Update `specs/<feature>/security-constraints.md` with any new findings.

### Step 5 — Architecture Refactor Generation

Run:
```text
/speckit.architecture-guard.refactor-generator
```

It MUST convert architecture findings into:
- Explicit implementation, migration, or refactor tasks.
- Boundary-level or contract-level corrections.
- **Prefer module-level tasks** over broad system rewrites.

### Step 6 — Proactive Durable Memory Preservation

If the task generation or security review identified new architectural lessons or reusable patterns:
1. **Proactive Execution**: You **MUST** proactively execute `/speckit.memory-md.capture` as the final part of this turn.
2. **Standard**: Use the formal capture flow to propose entries and wait for user approval.

### Step 7 — Task Governance Summary

Produce a final `Governed Tasks Summary` for the user.

## Graceful Degradation

**Without Memory Hub**:
- Skip Step 2 (Memory Synthesis)
- Continue to `/speckit.tasks` directly
- Assume no historical task constraints beyond Constitution

**Without Security Review**:
- Skip Step 4 (Security Review on Tasks)
- Continue to refactor-generator directly
- Flag missing security task validation in summary

**If No Architecture Violations**:
- Report "Architecture refactor tasks: None"
- Task list is complete

**Minimal Viable Workflow** (only Architecture Guard + Spec Kit):
- Generate tasks via core Spec Kit
- Validate against Constitution + architecture boundaries
- Produce summary

## Output Structure

The command MUST return:

```markdown
# Governed Tasks Summary

## Memory Context
- **Status**: [Synthesized / Skipped / Missing]
- **Relevant Decisions**: [List of historical constraints affecting these tasks]

## Security Task Review
- **Missing Security Tasks**: [List of missing auth/val/audit tasks]
- **Constraints**: [Key security boundaries to respect]

## Architecture Task Review
- **Refactor Tasks**: [Tasks generated by refactor-generator]
- **Migration Tasks**: [Specific steps for architectural migration]
- **Architecture Risks**: [Drift or conflicts detected in the task list]

## Recommended Next Step
- [e.g., Continue to /speckit.architecture-guard.governed-implement]
- [e.g., Revise tasks to address missing security items]
- [e.g., Update architecture constitution if standard is outdated]
- **Durable Memory Preservation**: (Proactively triggered) Review the proposed memory entries below.
```

## Output Rules

- **Separation**: Clearly separate implementation tasks, security tasks, and architecture refactor tasks.
- **Precision**: Do NOT merge findings into vague task items.
- **Non-Blocking**: Findings are advisory by default.
