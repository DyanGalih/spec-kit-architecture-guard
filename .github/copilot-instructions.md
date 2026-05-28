<!-- flash-mem-protocol-start v3 -->
# flash-mem

## Goal
Keep durable project memory current and easy to retrieve.

## Rules
- Search first: read `get_project_summary` and `search_memory` before changing code.
- Store only durable knowledge: decisions, conventions, constraints, bugs, workflows.
- Write immediately: use `add_memory` for new durable facts and `update_memory` for changes.
- Update summaries when architecture or shared conventions change.
- Prefer explicit deletion with audit trail.

## Tools
- Read: `get_project_summary`, `search_memory`, `get_relevant_context`
- Write: `add_memory`, `update_memory`, `delete_memory`
- Maintain: `capture_artifact_memory`, `export_markdown`, `rebuild_index`

## Workflow
1. Read summary.
2. Search memory.
3. Add or update durable memory.
4. Update summary when needed.

Use `flash-mem update` to refresh this block if it changes.
<!-- flash-mem-protocol-end -->