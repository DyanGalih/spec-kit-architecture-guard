---
description: Generate or validate implementation tasks with memory context, security constraints, and architecture refactor/migration awareness.
---

# Governed Tasks Command

You are orchestrating the `governed-tasks` workflow for `architecture-guard`.

This command coordinates multiple extensions to ensure the task list respects architectural, historical, and security constraints before implementation begins.

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
1. Implementation tasks are historical-context aware when Flash-Mem is available.
2. A task list is generated or validated (`/speckit.tasks`).
3. Security requirements are represented in tasks (Security Review).
4. Architecture refactors or migrations are represented in tasks (Architecture Guard).
5. The tasks are formally analyzed for gaps and severities (`/speckit.analyze`).
6. An automatic loop is offered to clarify and revise tasks if gaps are found.

## Orchestration Flow

### Step 1 — Detect Optional Integrations

Check for the availability of:
- `flash-mem` MCP server
- `spec-kit-security-review` extension

**Detection Logic**:
1. Detect `flash-mem` as an MCP-backed memory service in the current environment. Do not treat it as a Spec Kit extension or look for it in `.specify/extensions.yml`.
2. Read `.specify/extensions.yml` and check the `installed` list for `spec-kit-security-review`. Fall back to checking for the extension directory in `.specify/extensions/` only if the YAML is missing or the list is empty.
3. If either capability is missing, degrade gracefully by skipping only its respective steps.

### Step 2 — Flash-Mem MCP Context Retrieval (Optional)

When Flash-Mem is available, use it first to gather the most relevant architectural context before task generation. Prefer summary-first context and only expand into repository files when needed.

If Flash-Mem is unavailable or the context is insufficient, continue with the repository artifacts and constitution files available in the workspace.

**[OPTIONAL SUB-AGENT DELEGATION]**
- If the available Flash-Mem context is large or highly branched: Consider sub-agent support for synthesis
- Sub-agent command: Use the memory synthesis sub-agent when the context is too broad for inline synthesis.
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
   - Use Flash-Mem context and `specs/<feature>/security-constraints.md` if available.
   - Generate `specs/<feature>/tasks.md` directly, breaking down the plan into implementation-ready tasks with checkbox format.
   - Note in the Governance Summary that `/speckit.tasks` was unavailable and task generation was performed inline.

2. The generated tasks MUST use the Project Constitution documents and feature context. Use Flash-Mem first when available. If Flash-Mem is unavailable or the retrieved context is insufficient, read the constitution files directly with your file-reading tools (absolute or relative paths). Do not rely solely on workspace search or semantic indexers, as these files are often in `.gitignore`:
   - `.specify/memory/constitution.md`, `.specify/memory/architecture_constitution.md`, and `.specify/memory/security_constitution.md`.
   - `specs/<feature>/security-constraints.md` (if available).
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

### Step 6 — Orchestrate Spec Kit Analysis

You must orchestrate the `/speckit.analyze` workflow directly to serve as the formal analyst.

1. **Execute Analyze**: Run `/speckit.analyze` on the complete task list and architecture refactors.
2. **Architecture Validation**: Detect any gaps, missing requirements, or high-severity execution risks present in the implementation plan or task list.

### Step 7 — Proactive Durable Memory Preservation

If the task generation or security review identified new architectural lessons or reusable patterns:
1. **Proactive Execution**: You **MUST automatically execute** the durable-memory capture flow as the final part of this turn. Do not just recommend it; run the command.
2. **Standard**: Do not silently write memory outside the capture flow; let the formal capture flow propose entries and handle user approval.

### Step 8 — Task Governance Summary

Produce a final `Governed Tasks Summary` for the user.

### Step 9 — Automatic Analyst Loop

If the analyst (`/speckit.analyze`) finds any gaps, missing steps, or high severity issues in Step 6:
1. **Pause and Ask**: Conclude your response by asking the user:
   > *"The analyst found [number] gaps/severities in the tasks. Would you like me to automatically clarify and revise the tasks to address these findings?"*
2. **Execute if Approved**: If the user answers "yes" (or equivalent) in their next message, you must:
   - Automatically rewrite `specs/<feature>/tasks.md` to resolve the detected gaps.
   - Present the clean result.

## Graceful Degradation

**Without Flash-Mem MCP**:
- Skip Step 2 (Flash-Mem MCP Context Retrieval)
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
- Detect optional integrations
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
