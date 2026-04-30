#!/usr/bin/env bash
# check-architecture.sh — Verify architecture guard prerequisites.

set -euo pipefail

PROJECT_ROOT="${1:-.}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Checking Architecture Guard prerequisites in: $PROJECT_ROOT"

# --- 1. Constitution Check ---
CONSTITUTION_FOUND=0
for f in "CONSTITUTION.md" "docs/CONSTITUTION.md" "docs/PROJECT_CONTEXT.md"; do
  if [ -f "$PROJECT_ROOT/$f" ]; then
    echo -e "  ${GREEN}✓${NC} Found $f"
    CONSTITUTION_FOUND=1
    break
  fi
done

if [ $CONSTITUTION_FOUND -eq 0 ]; then
  echo -e "  ${RED}✗${NC} No CONSTITUTION.md or PROJECT_CONTEXT.md found."
  echo "    Architecture Guard needs a Constitution to validate against."
fi

# --- 2. Module Boundaries Check ---
# Just a soft check for common structures
if [ -d "$PROJECT_ROOT/src" ] || [ -d "$PROJECT_ROOT/app" ] || [ -d "$PROJECT_ROOT/modules" ]; then
  echo -e "  ${GREEN}✓${NC} Project has recognizable source boundaries."
else
  echo -e "  ${YELLOW}!${NC} No standard 'src', 'app', or 'modules' directory found."
  echo "    Ensure your Constitution defines boundaries clearly if using a custom structure."
fi

# --- 3. Spec Kit Check ---
if [ -d "$PROJECT_ROOT/specs" ]; then
  echo -e "  ${GREEN}✓${NC} Found specs/ directory."
else
  echo -e "  ${YELLOW}!${NC} No specs/ directory found. This extension is designed for Spec Kit workflows."
fi

# --- 4. Companion Check (Memory Hub) ---
if [ -d "$PROJECT_ROOT/docs/memory" ] || [ -f "$PROJECT_ROOT/.github/copilot-instructions.md" ]; then
  echo -e "  ${GREEN}✓${NC} Memory Hub context detected."
else
  echo -e "  ${YELLOW}!${NC} No Memory Hub context detected. Optional but recommended for better architecture reviews."
fi

echo ""
if [ $CONSTITUTION_FOUND -eq 1 ]; then
  echo -e "${GREEN}Prerequisites check complete.${NC}"
  exit 0
else
  echo -e "${RED}Prerequisites check failed.${NC}"
  exit 1
fi
