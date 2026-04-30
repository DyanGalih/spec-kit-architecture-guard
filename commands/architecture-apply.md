---
description: Apply approved architecture refactors by updating plan and task artifacts directly.
---

# Architecture Apply Command

You are applying approved architecture refactors for `spec-kit-architecture-guard`.

This is the write-capable companion to the review workflow. Use it when the team wants the architecture feedback reflected directly in planning artifacts instead of only receiving suggestions.

You may update plan and task artifacts, but you must keep the changes small, targeted, and non-blocking unless the Constitution explicitly requires a blocking change.

## Allowed Edits

You may revise:

- `plan.md`
- `tasks.md`
- Related task breakdown or checklist artifacts when they are part of the same Spec Kit workflow

You should not:

- Rewrite the whole plan unnecessarily.
- Remove product intent or feature scope.
- Introduce framework-specific rules into the core workflow.
- Apply security, performance, or linting changes that belong to other concerns.

## Inputs To Consider

Review any available:

- Existing architecture review output.
- Approved refactor tasks.
- Constitution rules.
- Feature specification.
- Current plan artifact.
- Current tasks artifact.
- Existing architecture decisions from memory context.
- Optional adapter guidance, if available.

## Apply Procedure

1. Identify the approved architecture changes that should be reflected in `plan.md` or `tasks.md`.
2. Preserve the feature intent and implementation scope.
3. Add or refine task entries for refactors that are safe to schedule.
4. Reorder tasks when architectural dependencies matter.
5. Update plan language so boundaries, contracts, and ownership are explicit.
6. Keep implementation moving unless the Constitution explicitly says the issue is blocking.
7. If a refactor is too large for the current scope, create a scoped task rather than expanding the whole plan.

## Write-Back Rules

- Prefer incremental edits over replacement.
- Keep existing decisions unless the new architecture finding clearly invalidates them.
- Make task titles actionable and specific.
- Preserve any accepted deviation if it was already documented.
- If the review output is uncertain, do not force a write-back; leave a note instead.

## Output Format

Return the changed artifact summary and the updated planning content in the standard Spec Kit artifact format.

