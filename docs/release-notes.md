# Release Notes

## 1.8.11

- Bumped the extension version to 1.8.11 and aligned the install artifacts and badges with the new release tag.
- Preserved the `flash-mem` backend migration so governed workflows continue to use `flash-mem` as the canonical MCP source.

## 2026-05-13

- Updated governed Architecture Guard workflows to be memory-first when `flash-mem` is available.
- `governed-plan`, `governed-tasks`, `governed-implement`, `architecture-workflow`, `architecture-review`, `architecture-apply`, and `architecture-verify` now prefer `memory-synthesis.md` before broader scans.
- README and command registry descriptions now reflect the memory-first orchestration model instead of treating `flash-mem` as merely supplemental.
