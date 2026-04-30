#!/usr/bin/env bash
# test-install.sh — Smoke tests for the architecture-guard repo.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB_ROOT="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TESTS=0
FAILURES=0

assert_file_exists() {
  TESTS=$((TESTS + 1))
  if [ -f "$1" ]; then
    echo -e "  ${GREEN}✓${NC} $2"
  else
    echo -e "  ${RED}✗${NC} $2 — file not found: $1"
    FAILURES=$((FAILURES + 1))
  fi
}

# --- Test: Hub has required files ---
echo ""
echo "Test: Hub repo structure is valid"

assert_file_exists "$HUB_ROOT/extension.yml" "extension.yml exists at root"
assert_file_exists "$HUB_ROOT/README.md" "README.md exists at root"
assert_file_exists "$HUB_ROOT/LICENSE" "LICENSE exists at root"

EXPECTED_COMMANDS=(
  "architecture-workflow.md"
  "architecture-review.md"
  "violation-detection.md"
  "refactor-generator.md"
  "architecture-apply.md"
)

for cmd in "${EXPECTED_COMMANDS[@]}"; do
  assert_file_exists "$HUB_ROOT/commands/$cmd" "command file: $cmd"
done

# --- Test: extension.yml references existing files ---
echo ""
echo "Test: extension.yml command files resolve"

while IFS= read -r line; do
  file_ref=$(echo "$line" | sed "s/.*file: *'\{0,1\}\([^']*\)'\{0,1\}/\1/")
  if [ -n "$file_ref" ]; then
    # clean up potential yaml noise
    file_ref=$(echo "$file_ref" | tr -d '"' | tr -d "'")
    assert_file_exists "$HUB_ROOT/$file_ref" "extension.yml ref: $file_ref"
  fi
done < <(grep 'file:' "$HUB_ROOT/extension.yml")

# --- Summary ---
echo ""
if [ "$FAILURES" -eq 0 ]; then
  echo -e "${GREEN}All $TESTS smoke tests passed.${NC}"
  exit 0
else
  echo -e "${RED}$FAILURES of $TESTS tests failed.${NC}"
  exit 1
fi
