# Architecture Workflow Prompt

Use this prompt when you want one orchestration pass for architecture review with optional Memory Hub and Security Review context.

The workflow is serial and ownership-aware:

1. Read Memory Hub context and `specs/<feature>/memory-synthesis.md` if they are available.
2. Run the architecture review against the Constitution, memory synthesis, and generic architecture principles.
3. Route security-first findings to Security Review instead of duplicating them here.
4. Produce refactor tasks or an apply recommendation for architecture findings.

## Goal

Review the current specification, plan, task list, or implementation with a single workflow and produce the most useful next step.

## Inputs

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
- Optional adapter guidance, if present.

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

## Output Format

Return the architecture review output, followed by a short workflow summary that notes any Memory Hub context used and any Security Review handoff that was identified.
