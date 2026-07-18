#!/usr/bin/env bash
# Create reproducible benchmark fixtures outside the source tree.

set -euo pipefail

TARGET_ROOT="${1:-}"

if [ -z "$TARGET_ROOT" ]; then
  echo "Usage: $0 <empty-target-directory>" >&2
  exit 2
fi

if [ -e "$TARGET_ROOT" ] && [ -n "$(find "$TARGET_ROOT" -mindepth 1 -print -quit 2>/dev/null)" ]; then
  echo "Target must be empty: $TARGET_ROOT" >&2
  exit 2
fi

mkdir -p "$TARGET_ROOT"

create_profile() {
  profile="$1"
  count="$2"
  index=1

  while [ "$index" -le "$count" ]; do
    feature_id=$(printf "%03d" "$index")
    feature_dir="$TARGET_ROOT/$profile/specs/$feature_id-feature"
    mkdir -p "$feature_dir"

    conflict_line=""
    if { [ "$profile" = "medium" ] || [ "$profile" = "large" ]; } && [ "$index" -eq 2 ]; then
      conflict_line="- FR-$feature_id: Conflicts with FR-001 over synchronous versus asynchronous notification delivery."
    fi

    printf '%s\n' \
      "# Feature $feature_id" \
      "" \
      "Purpose: Provide benchmark behavior for $profile profile feature $feature_id." \
      "" \
      "## Requirements" \
      "- FR-$feature_id: Preserve tenant isolation across every request." \
      "- AC-$feature_id: The active workflow records notification delivery evidence." \
      "${conflict_line:-}" \
      "" \
      "## Dependencies" \
      "- Depends on the shared identity boundary defined by feature 001." \
      > "$feature_dir/spec.md"

    index=$((index + 1))
  done
}

create_profile small 3
create_profile medium 12
create_profile large 31

echo "Created context-budget fixtures under $TARGET_ROOT"
