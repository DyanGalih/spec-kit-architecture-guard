# Release Notes

## 1.8.18

- Introduced the `governed-spec` orchestrator command. This command fills the gap before the `governed-plan` phase by chaining `speckit.specify` and `speckit.clarify` together.
- Formalized the `speckit.analyze` Analyst step inside the `governed-tasks` flow, introducing an Automatic Analyst Loop that pauses to repair execution gaps before moving to implementation.
- Updated README with clearer reasoning on why developers should use the governed orchestration flows.

## 1.8.17

- Centralized brownfield and greenfield onboarding guidance in the README quick start and trimmed duplicate references across supporting docs.
- Added and registered the `init-brownfield` command for existing codebases.
- Bumped the extension version and aligned the release badge and download links to `v1.8.17`.

## 1.8.15

- Refined the Flash-Mem-first orchestration wording across governed and architecture prompts.
- Synced the release artifacts, download links, and badge to `v1.8.15`.

## 1.8.14

- Enhanced the architecture commands with Flash-Mem context retrieval guidance.
- Aligned the install artifacts and badge with `v1.8.14`.

## 1.8.13

- Tightened the architecture workflow handoffs and related orchestration notes.
- Aligned the install artifacts and badge with `v1.8.13`.

## 1.8.12

- Made the `update_project_summary` execution in the architecture init command conditional upon `flash-mem` availability to ensure backward compatibility.

## 1.8.11

- Bumped the extension version to 1.8.11 and aligned the install artifacts and badges with the new release tag.
- Preserved the `flash-mem` backend migration so governed workflows continue to use `flash-mem` as the canonical MCP source.

## 2026-05-13

- Updated governed Architecture Guard workflows to be memory-first when `flash-mem` is available.
- `governed-plan`, `governed-tasks`, `governed-implement`, `architecture-workflow`, `architecture-review`, `architecture-apply`, and `architecture-verify` now prefer `memory-synthesis.md` before broader scans.
- README and command registry descriptions now reflect the memory-first orchestration model instead of treating `flash-mem` as merely supplemental.
