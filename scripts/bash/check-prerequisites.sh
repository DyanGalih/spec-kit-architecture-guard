#!/usr/bin/env bash
# check-prerequisites.sh — Locate the active Spec Kit feature directory and output artifact paths.
#
# Used by architecture-verify.md as the {SCRIPT} source to find the active
# FEATURE_DIR and derive absolute paths for spec.md, plan.md, and tasks.md.
#
# Discovery order:
#   1. First positional argument treated as explicit feature path.
#   2. Most recently modified directory under specs/ in the working tree.
#   3. specs/ root itself (fallback when no subdirectory is found).
#
# Usage: ./check-prerequisites.sh [feature-path] [OPTIONS]
#
# OPTIONS:
#   --json          Output in JSON format (for machine consumption)
#   --paths-only    Suppress status/warning lines; output paths only
#   --help, -h      Show this help message
#
# EXIT CODES:
#   0  Feature directory found; artifact paths derived
#   1  Error (specs/ missing, not a git repo, bad arguments)
#   2  Feature directory found but one or more artifact files are missing

set -e

# --- Argument parsing ---
JSON_MODE=false
PATHS_ONLY=false
EXPLICIT_FEATURE=""

for arg in "$@"; do
    case "$arg" in
        --json)       JSON_MODE=true ;;
        --paths-only) PATHS_ONLY=true ;;
        --help|-h)
            cat << 'EOF'
Usage: check-prerequisites.sh [feature-path] [OPTIONS]

Locate the active Spec Kit feature directory and derive artifact paths.

OPTIONS:
  --json          Output in JSON format
  --paths-only    Suppress status/warning lines; output paths only
  --help, -h      Show this help message

EXIT CODES:
  0  Feature directory found; artifact paths derived
  1  Error (specs/ missing, bad arguments)
  2  Feature directory found but one or more artifact files are missing
EOF
            exit 0
            ;;
        --*) echo "ERROR: Unknown option '$arg'" >&2; exit 1 ;;
        *)
            if [ -z "$EXPLICIT_FEATURE" ]; then
                EXPLICIT_FEATURE="$arg"
            fi
            ;;
    esac
done

# --- Locate repo root ---
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# --- Locate specs/ ---
SPECS_DIR="$REPO_ROOT/specs"
if [ ! -d "$SPECS_DIR" ]; then
    if ! $PATHS_ONLY && ! $JSON_MODE; then
        echo "ERROR: specs/ directory not found in $REPO_ROOT" >&2
    fi
    exit 1
fi

# --- Resolve feature directory ---
if [ -n "$EXPLICIT_FEATURE" ]; then
    # Allow absolute or relative paths
    if [[ "$EXPLICIT_FEATURE" == /* ]]; then
        FEATURE_DIR="$EXPLICIT_FEATURE"
    else
        FEATURE_DIR="$REPO_ROOT/$EXPLICIT_FEATURE"
    fi
    if [ ! -d "$FEATURE_DIR" ]; then
        echo "ERROR: Feature directory not found: $FEATURE_DIR" >&2
        exit 1
    fi
else
    # Find the most recently modified specs subdirectory
    FEATURE_DIR="$(find "$SPECS_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%T@ %p\n' 2>/dev/null \
        | sort -rn | head -n1 | awk '{print $2}')"

    if [ -z "$FEATURE_DIR" ]; then
        # Fall back to specs/ root itself
        FEATURE_DIR="$SPECS_DIR"
    fi
fi

# --- Derive artifact paths ---
SPEC_MD="$FEATURE_DIR/spec.md"
PLAN_MD="$FEATURE_DIR/plan.md"
TASKS_MD="$FEATURE_DIR/tasks.md"
MEMORY_SYNTHESIS="$FEATURE_DIR/memory-synthesis.md"
SECURITY_CONSTRAINTS="$FEATURE_DIR/security-constraints.md"

# --- Check file existence ---
MISSING_FILES=()
[ ! -f "$SPEC_MD" ]     && MISSING_FILES+=("spec.md")
[ ! -f "$PLAN_MD" ]     && MISSING_FILES+=("plan.md")
[ ! -f "$TASKS_MD" ]    && MISSING_FILES+=("tasks.md")

EXIT_CODE=0
[ ${#MISSING_FILES[@]} -gt 0 ] && EXIT_CODE=2

# --- Output ---
if $JSON_MODE; then
    MISSING_JSON="["
    for i in "${!MISSING_FILES[@]}"; do
        [ $i -gt 0 ] && MISSING_JSON+=","
        MISSING_JSON+="\"${MISSING_FILES[$i]}\""
    done
    MISSING_JSON+="]"

    printf '{"feature_dir":"%s","spec_md":"%s","plan_md":"%s","tasks_md":"%s","memory_synthesis":"%s","security_constraints":"%s","missing_files":%s}\n' \
        "$FEATURE_DIR" "$SPEC_MD" "$PLAN_MD" "$TASKS_MD" "$MEMORY_SYNTHESIS" "$SECURITY_CONSTRAINTS" "$MISSING_JSON"
else
    if $PATHS_ONLY; then
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo "SPEC_MD: $SPEC_MD"
        echo "PLAN_MD: $PLAN_MD"
        echo "TASKS_MD: $TASKS_MD"
        echo "MEMORY_SYNTHESIS: $MEMORY_SYNTHESIS"
        echo "SECURITY_CONSTRAINTS: $SECURITY_CONSTRAINTS"
    else
        echo "FEATURE_DIR: $FEATURE_DIR"
        echo ""
        echo "Artifact Paths:"
        echo "  spec.md:               $SPEC_MD"
        echo "  plan.md:               $PLAN_MD"
        echo "  tasks.md:              $TASKS_MD"
        echo "  memory-synthesis.md:   $MEMORY_SYNTHESIS"
        echo "  security-constraints:  $SECURITY_CONSTRAINTS"
        if [ ${#MISSING_FILES[@]} -gt 0 ]; then
            echo ""
            echo "Missing files: ${MISSING_FILES[*]}"
        fi
    fi
fi

exit $EXIT_CODE
