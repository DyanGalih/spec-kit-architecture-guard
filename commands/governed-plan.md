---
description: Orchestrate a governed planning workflow that coordinates flash-mem, Security Review, and Architecture Guard validation.
---

# Governed Plan Command

## Ponytail Core Contract

Before continuing, you **MUST** read and apply `.specify/extensions/architecture-guard/templates/ponytail_core.md`. In the extension source checkout, use `templates/ponytail_core.md`. Treat that shared contract as authoritative; phase-specific instructions may narrow its application but must not weaken its safety or verification floor.

You are orchestrating the `governed-plan` workflow for `architecture-guard`.

This command coordinates multiple extensions to ensure the technical plan respects architectural, historical, and security constraints before implementation begins.

## Flash-Mem-First Architecture Context Retrieval

Try Flash-Mem first: query summary and metadata context before performing architecture analysis.

1. Search Flash-Mem for relevant architecture context:
   - architecture decisions
   - ADRs
   - design constraints
   - coding conventions
   - prior guard findings
   - approved exceptions
   - architectural patterns
2. Prefer summary-first retrieval:
   - use summaries
   - use metadata
   - use confidence
   - use tags
   - use related files
3. Load full memory content only when summaries are insufficient.
4. Reuse approved architectural decisions whenever possible.
5. Flag conflicts between proposed changes and existing architectural decisions.
6. After analysis, store durable architecture knowledge back into Flash-Mem:
   - new architecture decisions
   - approved exceptions
   - recurring violations
   - architectural constraints
   - project conventions
   - validated design patterns

If Flash-Mem is unavailable or the retrieved summaries are insufficient, continue with the repository artifacts and constitution files available in the workspace.

## Goal

Provide a single command that ensures:
1. Historical lessons are applied from Flash-Mem when available.
2. A technical plan is generated (`/speckit.plan`).
3. Security boundaries are respected (Security Review).
4. Architectural drift is detected (Architecture Guard).

## Orchestration Flow

### Step 1 — Detect Optional Integrations

Check for the availability of:
- `flash-mem` MCP server
- `security-review` (or compatibility alias `spec-kit-security-review`) extension

**Detection Logic**:
1. Detect `flash-mem` as an MCP-backed memory service in the current environment. Do not treat it as a Spec Kit extension or look for it in `.specify/extensions.yml`.
2. Read `.specify/extensions.yml` and check the `installed` list for `security-review` (or compatibility alias `spec-kit-security-review`). Fall back to checking for the extension directory in `.specify/extensions/` only if the YAML is missing or the list is empty.
3. If either capability is missing, degrade gracefully by skipping only its respective steps.

### Step 2 — Flash-Mem MCP Context Retrieval (Optional)

When Flash-Mem is available, use it first to gather the most relevant architectural context before plan generation. Prefer summary-first context and only expand into repository files when needed.

If Flash-Mem is unavailable or the context is insufficient, continue with the repository artifacts and constitution files available in the workspace.

**[OPTIONAL SUB-AGENT DELEGATION]**
- If the available Flash-Mem context is large or highly branched: Consider sub-agent support for synthesis
- Sub-agent command: Use the memory synthesis sub-agent when the context is too broad for inline synthesis.
- Sub-agent benefits: Faster traversal, better filtering, detailed synthesis
- LLM decides: Inline for quick decisions, sub-agent for complex memory

---

### Step 3 — Orchestrate Spec Kit Plan

You must orchestrate the `/speckit.plan` workflow directly.

**CRITICAL INSTRUCTION**: You must NOT just advise the user or stop here. You must actually generate the plan:
1. **Apply Ponytail Pragmatism**: Instruct the agent to act as a "lazy senior developer." The generated plan must prefer standard libraries and native platform features over proposing complex new abstractions. Strictly enforce YAGNI.
   - Also prefer one shared plan path for repeated behavior instead of separate duplicated steps or parallel implementations.
2. **Execute Plan**: Run `/speckit.plan` to generate and save `specs/<feature>/plan.md`.

   **If `/speckit.plan` is not available as a registered command** (i.e., the AI agent does not recognize it as a slash command), fall back to inline planning:
   - Read the active spec at `specs/<feature>/spec.md` (or the path provided by the user).
   - Read all applicable constitution files (`.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, `.specify/memory/security_constitution.md`).
   - Use Flash-Mem context if available.
   - Generate `specs/<feature>/plan.md` directly, incorporating all context above and enforcing Ponytail minimalism.
   - Note in the Governance Summary that `/speckit.plan` was unavailable and planning was performed inline.

3. The planning process must incorporate the Project Constitution documents and memory synthesis. Use Flash-Mem first when available. If Flash-Mem is unavailable or the retrieved context is insufficient, read the constitution files directly with your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:
   - `.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, and `.specify/memory/security_constitution.md`.
4. Prefer the cached synthesis and selected index entries over reopening the full durable memory set.

### Step 4 — Security Review (Optional)

IF `security-review` (or compatibility alias `spec-kit-security-review`) is available:
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
- Flash-Mem context (if available).
- `security-constraints.md` (if available).

Detect any `Security-Architecture Conflict` or architectural drift.

### Step 6 — Proactive Durable Memory Preservation

If the planning process or architecture validation identified new architectural patterns, critical decisions, or repeatable lessons:
1. **Proactive Execution**: You **MUST automatically execute** the durable-memory capture flow as the final action of this turn. Do not just recommend it; run the command.
2. **Standard**: Do not silently write memory outside the capture flow; let the formal capture flow propose entries and handle user approval.

### Step 7 — Generate Governance Summary

Produce a final `Governed Planning Summary` for the user.

## Graceful Degradation

**Without Flash-Mem MCP**:
- Skip Step 2 (Flash-Mem MCP Context Retrieval)
- Continue to `/speckit.plan` directly
- Assume no historical architecture constraints beyond Constitution
- Plan-level review proceeds with Constitution + Architecture Guard only

**Without Security Review**:
- Skip Step 4 (Security Review)
- Continue to violation-detection directly
- Flag missing security validation in governance summary
- Plan-level review proceeds with architecture constraints only

**Minimal Viable Workflow** (only Architecture Guard + Spec Kit):
- Detect optional integrations
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
- **Decoupled**: Do not tightly couple the logic to the internals of other extensions; rely on documented context and repository artifacts.
