---
description: Run a single architecture workflow that can incorporate optional memory and security context when available.
---

# Architecture Workflow Command

You are running `architecture-guard` as the single orchestration entry point for architecture review.

Use this command when the user wants one pass that covers architecture review, optional Memory Hub context, optional Security Review handoff, and optional performance mode without manually chaining multiple commands.

This command accepts the same normalized command context as `architecture-review`, including semantic and dot-style aliases.

The workflow is serial and ownership-aware:

1. Read Memory Hub context and `specs/<feature>/memory-synthesis.md` if they are available.
2. Normalize `mode` and `focus` from the incoming command.
3. Run the architecture review against the Constitution, memory synthesis, and generic architecture principles.
4. If `mode=performance`, keep the pass advisory and route output to `Performance Insights` only.
5. Route security-first findings to Security Review instead of duplicating them here.
6. If `mode=architecture` and a Constitution Update Proposal is warranted, surface it and leave application to `architecture-apply`.
7. Produce refactor tasks or an apply recommendation for architecture findings.

## Goal

Review the current specification, plan, task list, or implementation with a single workflow and produce the most useful next step.

## Inputs To Consider

Review any available:

- Constitution rules.
- Feature specification.
- Implementation plan.
- Task list.
- Code changes or implementation summary.
- Module or service boundaries.
- Existing contract conventions.
- Existing validation patterns.
- Existing response or output patterns.
- Stored architecture decisions from Memory Hub, if present.
- Security Review findings, if present.
- Optional preset guidance, if present.

## Workflow

1. Read optional Memory Hub context if it is available in the project or workflow context.
2. Review the current work against the Constitution and generic architecture principles.
3. Identify whether any finding is primarily security-related.
4. If a finding is security-related, flag it as a handoff to Security Review rather than treating it as a core architecture finding.
5. Produce refactor tasks or an apply recommendation as needed.
6. Prefer a single concise summary that tells the user what to fix next.

## Rules

- Do not invent framework-specific conventions.
- Do not invent unsupported Spec Kit APIs.
- Do not block implementation by default.
- Do not replace Security Review; route security-first findings to Security Review when available.
- Do not require Memory Hub; treat it as optional read-only context only.
- Do not duplicate Security Review findings in the architecture output unless the issue is specifically an architectural boundary problem.
- Do not write security follow-up items into architecture tasks or plan updates.
- Do not write memory conclusions into architecture follow-up items.

When `mode=performance`, do not produce violations or refactor tasks.

## Output Format

All governance reports MUST follow this standard template:

```markdown
# Architecture Governance Report

## Input Summary
- **Artifacts Scanned**: [list]
- **Extensions Used**: [Memory Hub: yes/no, Security Review: yes/no]
- **Mode**: [architecture/performance]
- **Focus**: [general/db/api/async]

## Findings

### Violations
[Table format with: ID | Category | Severity | Location | Summary | Evidence]

### Refactor Tasks (if any)
[Task list or "None"]

### Constitution Update Proposals (if any)
[Proposals or "None"]

## Context Applied
- **Memory Hub**: [Used context or "Not available"]
- **Security Review**: [Findings routed or "Not available"]

## Recommended Next Step
[Single clear action]
```
