# Contributing to Architecture Guard

Thank you for your interest in contributing!

## Repository Structure

```
extension.yml          ← extension manifest
commands/              ← Spec Kit command definitions (single source of truth)
templates/             ← Starter files for target projects (constitution.md)
presets/               ← Framework-specific presets (Django, Express, Laravel, etc.)
examples/              ← Usage examples for different architectures
scripts/               ← Maintenance and verification scripts
```

## Development Workflow

### Rule Changes

If you want to modify architecture rules or detection logic:

1. Update the relevant file in `commands/`. Each command file is self-contained with its full rules, detection logic, and output format.
2. Run `./scripts/test-install.sh` to verify consistency.

### SonarLint Rules Bundle Updates

The `.github/sonar-rules/` directory contains bundled SonarLint rules used during architecture review (Step 7b).

**To update the rules bundle** (quarterly recommended):

```bash
./scripts/bash/extract-sonar-rules.sh --commit
```

This will:
1. Verify `sonarlint` CLI is installed
2. Extract all available rules
3. Filter for architecture-relevant tags (coupling, complexity, structure, dependency, performance)
4. Update `sonarlint-rules.json` and `rules-manifest.json`
5. Auto-commit if changes detected

**To update without auto-commit:**

```bash
./scripts/bash/extract-sonar-rules.sh
# Review changes
git diff .github/sonar-rules/
# Manually commit
git add .github/sonar-rules/ && git commit -m "chore: update SonarLint rules bundle"
```

See `.github/sonar-rules/README.md` for details.

### Sub-Agent Delegation Pattern

Commands in `commands/` can optionally delegate complex analysis to sub-agents using a hybrid model.

**When to mark a step for optional delegation:**
- Memory synthesis (traversing 20+ decision documents)
- Large codebase scanning (50+ files or 10,000+ lines)
- Parallel analysis (rule evaluation, filtering, categorization)
- Complex decision trees (framework detection, multi-stage interviews)

**Syntax in commands:**
```markdown
### Step X — [Task Name]

**[OPTIONAL SUB-AGENT DELEGATION]**
- If [condition] (e.g., file_count ≥ 50):
  - Consider delegating to sub-agent
  - Sub-agent command: `/command-name`
  - Sub-agent benefits: [parallelization, speed, etc.]
  - LLM decides: Inline for [quick case], sub-agent for [complex case]

[Inline procedure steps...]

**If delegated to sub-agent:**
- Sub-agent receives [inputs]
- Returns [structured output]
- Main agent integrates [how to integrate]
```

**Decision logic for LLM:**
- Complexity < threshold → Handle inline (fast)
- Complexity ≥ threshold → Delegate (thorough)
- Explicit flags (`--inline` / `--delegate`) override auto-detection

**Current markers in commands:**
- `architecture-review.md` Step 7b (SonarLint): Delegate if ≥ 50 files
- `governed-plan.md` Step 2 (Memory synthesis): Delegate if ≥ 20 memory docs
- `governed-tasks.md` Step 2 (Memory synthesis): Delegate if ≥ 20 memory docs
- `governed-implement.md` Step 2 (Memory synthesis): Delegate if ≥ 20 memory docs

### Adding Examples

Add new example scenarios to the `examples/` directory. Use the generic backend/frontend format to keep them framework-agnostic.

### Testing

Run the smoke tests:

```bash
./scripts/test-install.sh
```

## Guidelines

- **Framework-Agnostic**: Keep the core extension free of framework-specific logic. Use Generic Architecture terminology (Entry Boundary, Validation Boundary, etc.).
- **Non-Blocking**: Ensure violations are reported as refactor tasks and do not block the main workflow unless explicitly required by the Constitution.
- **Actionable**: Refactor tasks must be specific, scoped, and prioritized.

## Pull Requests

1. Fork the repository.
2. Create your feature branch.
3. Commit your changes.
4. Run tests and verify with `scripts/check-architecture.sh` on a sample project.
5. Submit a PR with a clear description of the impact.
