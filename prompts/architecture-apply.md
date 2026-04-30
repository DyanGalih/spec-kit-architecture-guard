# Architecture Apply Prompt

Use this prompt when the team wants approved architecture refactors applied directly to planning artifacts rather than only suggested.

## Goal

Update `plan.md` and/or `tasks.md` so the architecture feedback becomes part of the working plan.

## Guidelines

- Keep edits small and surgical.
- Preserve feature intent.
- Do not rewrite the entire plan unless the existing structure is fundamentally incompatible.
- Do not introduce framework-specific assumptions in the core extension.
- Do not duplicate security-review, performance review, or linting concerns.
- If a refactor is not ready for direct application, convert it into a scoped task instead.

## Inputs

Use any available:

- Architecture review findings.
- Approved refactor tasks.
- Constitution rules.
- Feature specification.
- Plan artifact.
- Tasks artifact.
- Memory context.
- Optional adapter guidance.

## Application Rules

- Boundary issues should be reflected as explicit ownership, contract, or validation tasks.
- Consistency issues should be turned into normalized task wording or explicit plan notes.
- High-risk architectural drift should be converted into task ordering or explicit dependencies.
- If the plan already contains a related task, refine it rather than duplicating it.
- If the task list is missing a necessary refactor, add a new scoped task.

## Output Format

Return the updated artifact content with a short change summary.

