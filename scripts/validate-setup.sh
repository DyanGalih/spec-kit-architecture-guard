#!/usr/bin/env bash
# validate-setup.sh — Verify all Architecture Guard prerequisites before running governed workflows.
# Usage: ./scripts/validate-setup.sh [project-root]

set -euo pipefail

PROJECT_ROOT="${1:-.}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

pass()    { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; WARNINGS=$((WARNINGS + 1)); }
fail()    { echo -e "  ${RED}✗${NC} $1"; ERRORS=$((ERRORS + 1)); }
section() { echo -e "\n${BOLD}${CYAN}$1${NC}"; }

echo -e "${BOLD}Architecture Guard — Setup Validator${NC}"
echo "Project root: $PROJECT_ROOT"

# ─── 1. Constitution Files ───────────────────────────────────────────────────
section "1. Constitution Files"

if [ -f "$PROJECT_ROOT/.specify/memory/constitution.md" ]; then
  pass "Governance constitution found (.specify/memory/constitution.md)"
else
  fail "Governance constitution missing (.specify/memory/constitution.md)"
  echo "       Run /speckit.architecture-guard.init to create it."
fi

if [ -f "$PROJECT_ROOT/.specify/memory/architecture_constitution.md" ]; then
  pass "Architecture constitution found (.specify/memory/architecture_constitution.md)"
else
  fail "Architecture constitution missing — this is the primary validation source."
  echo "       Run /speckit.architecture-guard.init to create it."
fi

if [ -f "$PROJECT_ROOT/.specify/memory/security_constitution.md" ]; then
  pass "Security constitution found (.specify/memory/security_constitution.md)"
else
  warn "Security constitution not found (.specify/memory/security_constitution.md)"
  echo "       Optional but recommended when using governed-plan or security-review."
fi

# ─── 2. Spec Kit Structure ───────────────────────────────────────────────────
section "2. Spec Kit Structure"

if [ -d "$PROJECT_ROOT/specs" ]; then
  pass "specs/ directory found"
  SPEC_COUNT=$(find "$PROJECT_ROOT/specs" -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')
  if [ "$SPEC_COUNT" -gt 0 ]; then
    pass "Found $SPEC_COUNT feature spec director$([ "$SPEC_COUNT" -eq 1 ] && echo 'y' || echo 'ies') in specs/"
  else
    warn "specs/ is empty — no feature directories found yet"
  fi
else
  warn "No specs/ directory — Architecture Guard expects Spec Kit workflow directories here"
fi

if [ -d "$PROJECT_ROOT/.specify" ]; then
  pass ".specify/ directory found"
else
  fail ".specify/ directory missing — run 'specify init' to bootstrap Spec Kit"
fi

# ─── 3. Optional Extension: Memory Hub ───────────────────────────────────────
section "3. Optional Extension: Memory Hub"

MEMORY_FOUND=0
if grep -q '"memory-md"' "$PROJECT_ROOT/.specify/extensions.yml" 2>/dev/null || \
   grep -q 'memory-md' "$PROJECT_ROOT/.specify/extensions.yml" 2>/dev/null; then
  pass "memory-md declared in .specify/extensions.yml"
  MEMORY_FOUND=1
elif [ -d "$PROJECT_ROOT/.specify/extensions/memory-md" ]; then
  pass "memory-md extension directory found (.specify/extensions/memory-md)"
  MEMORY_FOUND=1
else
  warn "Memory Hub (memory-md) not installed — governed workflows will skip memory synthesis"
  echo "       Install with: specify integration add memory-md"
fi

if [ "$MEMORY_FOUND" -eq 1 ]; then
  if [ -f "$PROJECT_ROOT/.specify/extensions/memory-md/config.yml" ]; then
    pass "Memory Hub config found (.specify/extensions/memory-md/config.yml)"
    if grep -q 'optimizer.enabled: true\|enabled: true' "$PROJECT_ROOT/.specify/extensions/memory-md/config.yml" 2>/dev/null; then
      pass "Memory Hub optimizer is enabled — SQLite acceleration active"
    else
      warn "Memory Hub optimizer is disabled — running in markdown-only mode (higher token usage)"
      echo "       Set 'optimizer.enabled: true' in config.yml to enable SQLite acceleration"
    fi
  else
    warn "Memory Hub config not found — using defaults (markdown-only, no optimizer)"
  fi

  if [ -f "$PROJECT_ROOT/docs/memory/INDEX.md" ]; then
    ENTRY_COUNT=$(grep -c '^|' "$PROJECT_ROOT/docs/memory/INDEX.md" 2>/dev/null || echo 0)
    pass "docs/memory/INDEX.md found ($ENTRY_COUNT table row(s))"
  else
    warn "docs/memory/INDEX.md not found — run /speckit.memory-md.init to initialize memory files"
  fi
fi

# ─── 4. Optional Extension: Security Review ──────────────────────────────────
section "4. Optional Extension: Security Review"

if grep -q 'security-review' "$PROJECT_ROOT/.specify/extensions.yml" 2>/dev/null || \
   [ -d "$PROJECT_ROOT/.specify/extensions/security-review" ]; then
  pass "security-review extension found — governed-plan will include security validation"
else
  warn "Security Review not installed — governed workflows will skip security boundary checks"
  echo "       Install with: specify integration add security-review"
fi

# ─── 5. Source Structure ─────────────────────────────────────────────────────
section "5. Source Structure"

SOURCE_FOUND=0
for dir in src app modules lib; do
  if [ -d "$PROJECT_ROOT/$dir" ]; then
    pass "Source directory found: $dir/"
    SOURCE_FOUND=1
    break
  fi
done

if [ "$SOURCE_FOUND" -eq 0 ]; then
  warn "No standard source directory found (src/, app/, modules/, lib/)"
  echo "       Ensure your architecture_constitution.md defines custom boundaries explicitly"
fi

# ─── 6. Governance: Note on Prompt-Based Execution ───────────────────────────
section "6. Execution Model"

echo -e "  ${CYAN}ℹ${NC}  Architecture Guard is a prompt governance layer."
echo     "     Validation quality depends on the AI agent following the command instructions."
echo     "     It does not perform static analysis or AST inspection."
echo     "     For stronger guarantees, pair it with SonarLint or a dedicated linter."

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}─── Summary ───────────────────────────────────────────${NC}"
if [ "$ERRORS" -gt 0 ]; then
  echo -e "  ${RED}✗ $ERRORS error(s) found — fix before running governed workflows${NC}"
fi
if [ "$WARNINGS" -gt 0 ]; then
  echo -e "  ${YELLOW}! $WARNINGS warning(s) — optional but recommended to address${NC}"
fi
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "  ${GREEN}✓ All checks passed — Architecture Guard is ready${NC}"
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "  ${GREEN}✓ No blocking errors — Architecture Guard can run${NC}"
fi

exit "$ERRORS"
