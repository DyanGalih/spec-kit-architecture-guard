---
description: Orchestrate a governed planning workflow that coordinates flash-mem, Security Review, and Architecture Guard validation.
---

# Governed Plan Command

You are orchestrating the `governed-plan` workflow for `architecture-guard`.

This command coordinates multiple extensions to ensure the technical plan respects architectural, historical, and security constraints before implementation begins.
The orchestrator should be memory-first: refresh or read `memory-synthesis.md` before any broader file scan, then fall back to targeted reads only when the synthesis is insufficient.
If `flash-mem` is available, use `/speckit.memory-md.prepare-context` or the MCP tools exposed by `flash-mem`; compatibility tool names such as `speckit_memory_*` are provided by `flash-mem` when the host still expects them.

## Goal

Provide a single command that ensures:
1. Historical lessons are applied (`flash-mem`).
2. A technical plan is generated (`/speckit.plan`).
3. Security boundaries are respected (Security Review).
4. Architectural drift is detected (Architecture Guard).

## Orchestration Flow

### Step 1 — Detect Optional Extensions

Check for the existence of:
- `flash-mem`
- `spec-kit-security-review`

**Detection Logic**:
1. Read `.specify/extensions.yml` and check the `installed` list. If an extension ID is present there, consider it available.
2. Fall back to checking for the extension directory in `.specify/extensions/` only if the YAML is missing or the list is empty.
3. If they are missing from both, degrade gracefully by skipping their respective steps.

### Step 2 — Memory Synthesis (Optional)

IF `flash-mem` is available:

#### SQLite / MCP Flow (Required for `flash-mem`)
Because `flash-mem` uses SQLite as its source of truth, you **MUST** use its MCP tools to retrieve context. Do not read the `.md` memory files directly, as they are only backups.

1. **Prepare Context**: Execute `/speckit.memory-md.prepare-context --feature specs/<feature>`.
2. **Read Synthesis**: Read `specs/<feature>/memory-synthesis.md` to identify constraints.
3. If `flash-mem` emits a token banner, keep it visible so the savings remain observable during normal planning runs.
4. **Token Report**: Execute the `speckit_memory_token_report` MCP tool provided by `flash-mem` with `feature: "<feature>"` and display the token savings in the summary.

#### Markdown-Only Flow (Fallback)
If `flash-mem` is unavailable, use the standard synthesis command:

1. **Execute Synthesis**: Run `/speckit.memory-md.plan-with-memory` to synthesize and save `specs/<feature>/memory-synthesis.md`.

**[OPTIONAL SUB-AGENT DELEGATION]**
- If `flash-mem` has ≥ 20 decision documents: Consider sub-agent for synthesis
- Sub-agent command: `/speckit.memory-md.plan-with-memory`
- Sub-agent benefits: Faster traversal, better filtering, detailed synthesis
- LLM decides: Inline for quick decisions, sub-agent for complex memory

---

### Step 3 — Orchestrate Spec Kit Plan

You must orchestrate the `/speckit.plan` workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must actually generate the plan:
1. **Execute Plan**: Run `/speckit.plan` to generate and save `specs/<feature>/plan.md`.

   **If `/speckit.plan` is not available as a registered command** (i.e., the AI agent does not recognize it as a slash command), fall back to inline planning:
   - Read the active spec at `specs/<feature>/spec.md` (or the path provided by the user).
   - Read all applicable constitution files (`.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, `.specify/memory/security_constitution.md`).
   - Read `specs/<feature>/memory-synthesis.md` if available.
   - Generate `specs/<feature>/plan.md` directly, incorporating all context above.
   - Note in the Governance Summary that `/speckit.plan` was unavailable and planning was performed inline.

2. The planning process must incorporate the Project Constitution documents and memory synthesis. **IMPORTANT**: You MUST read these files explicitly using your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:
   - `.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, and `.specify/memory/security_constitution.md`.
   - Also use `specs/<feature>/memory-synthesis.md` (if available).
3. Prefer the cached synthesis and selected index entries over reopening the full durable memory set.

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
- `.specify/memory/architecture_constitution.md`.
- `memory-synthesis.md` (if available).
- `security-constraints.md` (if available).

Detect any `Security-Architecture Conflict` or architectural drift.

### Step 6 — Proactive Durable Memory Preservation

If the planning process or architecture validation identified new architectural patterns, critical decisions, or repeatable lessons:
1. **Proactive Execution**: You **MUST automatically execute** `/speckit.memory-md.capture` as the final action of this turn. Do not just recommend it; run the command.
2. **Standard**: Do not silently write memory; use the formal capture flow to propose entries and wait for user approval.

### Step 7 — Generate Governance Summary

Produce a final `Governed Planning Summary` for the user.

## Graceful Degradation

**Without `flash-mem`**:
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
- **Durable Memory Preservation**: (Proactively triggered) Review the proposed memory entries below.
```

## Guardrails

- **Framework-Agnostic**: Do not assume specific framework conventions unless provided via a preset.
- **Non-Blocking**: Findings should be advisory by default unless they violate a P0 rule in the Constitution.
- **Incremental**: Prefer suggestions for incremental migration over full rewrites.
- **Decoupled**: Do not tightly couple the logic to the internals of other extensions; rely on documented artifact names (`memory-synthesis.md`, `security-constraints.md`).
