# Contributing to Architecture Guard

Thank you for your interest in contributing!

## Repository Structure

```
extension.yml          ← extension manifest
commands/              ← Spec Kit command definitions (single source of truth)
templates/             ← Starter files for target projects (constitution.md)
adapters/              ← Optional framework adapters (Currently README only)
examples/              ← Usage examples for different architectures
scripts/               ← Maintenance and verification scripts
```

## Development Workflow

### Rule Changes

If you want to modify architecture rules or detection logic:

1. Update the relevant file in `commands/`. Each command file is self-contained with its full rules, detection logic, and output format.
2. Run `./scripts/test-install.sh` to verify consistency.

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
