#!/bin/bash

##############################################################################
# extract-sonar-rules.sh
#
# Purpose:
#   Extract SonarLint rules from CLI and filter for architecture relevance.
#   Commits updated rules bundle if changes detected.
#
# Usage:
#   ./scripts/bash/extract-sonar-rules.sh [--commit]
#
# Options:
#   --commit    Auto-commit if rules changed (requires git)
#
##############################################################################

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RULES_DIR="$REPO_ROOT/src/sonar-rules"
RULES_FILE="$RULES_DIR/sonarlint-rules.json"
MANIFEST_FILE="$RULES_DIR/rules-manifest.json"
TEMP_RULES="/tmp/sonarlint-rules-raw.json"
COMMIT_ON_CHANGE=false

# Parse options
if [[ "$1" == "--commit" ]]; then
  COMMIT_ON_CHANGE=true
fi

echo "🔍 SonarLint Rules Extraction"
echo "========================================"

# Check if sonarlint is installed
if ! command -v sonarlint &> /dev/null; then
  echo ""
  echo "❌ ERROR: sonarlint CLI not found"
  echo ""
  echo "Install it with:"
  echo "  npm install -g sonarlint"
  echo "  OR"
  echo "  brew install sonarlint"
  echo ""
  exit 1
fi

SONARLINT_VERSION=$(sonarlint --version 2>/dev/null || echo "unknown")
echo "✅ Found sonarlint: $SONARLINT_VERSION"
echo ""

# Extract all rules
echo "📦 Extracting all SonarLint rules..."
if sonarlint --list-all-rules --format=json > "$TEMP_RULES" 2>/dev/null; then
  TOTAL_RULES=$(jq '. | length' "$TEMP_RULES" 2>/dev/null || echo "?")
  echo "✅ Extracted $TOTAL_RULES total rules"
else
  echo "❌ Failed to extract rules"
  exit 1
fi

# Filter for architecture-relevant rules
echo ""
echo "🎯 Filtering for architecture-relevant rules..."
ARCH_RULES=$(jq '[.[] | select(.tags[]? | IN("brain-overload", "complexity", "dependency", "structure", "performance"))]' "$TEMP_RULES")
ARCH_COUNT=$(echo "$ARCH_RULES" | jq '. | length')
echo "✅ Found $ARCH_COUNT architecture-relevant rules"

# Create new rules file
echo ""
echo "💾 Writing filtered rules to $RULES_FILE..."
echo "$ARCH_RULES" > "$RULES_FILE"

# Update manifest
echo "📝 Updating manifest..."
MANIFEST=$(jq \
  --arg version "$(grep -oP '(?<="sonarlint_cli_version": ")[^"]*' "$MANIFEST_FILE" || echo '1.0.0')" \
  --arg date "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg arch_count "$ARCH_COUNT" \
  --arg total_count "$TOTAL_RULES" \
  '.version = $version | .generated_at = $date | .architecture_rules_count = ($arch_count | tonumber) | .total_rules = ($total_count | tonumber)' \
  "$MANIFEST_FILE")
echo "$MANIFEST" > "$MANIFEST_FILE"

# Report changes
echo ""
echo "========================================"
echo "✅ EXTRACTION COMPLETE"
echo ""
echo "Summary:"
echo "  Total rules available: $TOTAL_RULES"
echo "  Architecture-relevant: $ARCH_COUNT"
echo "  Updated file: $RULES_FILE"
echo "  Updated manifest: $MANIFEST_FILE"
echo ""

# Git commit if requested and changes detected
if [[ "$COMMIT_ON_CHANGE" == true ]]; then
  cd "$REPO_ROOT"
  if git diff --quiet src/sonar-rules/ 2>/dev/null; then
    echo "✅ No changes to commit"
  else
    echo "📦 Committing changes..."
    git add src/sonar-rules/
    git commit -m "chore: update SonarLint rules bundle to $ARCH_COUNT architecture rules"
    echo "✅ Committed"
  fi
fi

echo ""
echo "💡 Next steps:"
echo "   Review changes: git diff src/sonar-rules/"
echo "   Commit manually: git add src/sonar-rules/ && git commit"
echo "   Or re-run with: $0 --commit"
