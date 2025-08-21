#!/bin/bash

# git-log-diff.sh - Wrapper script to safely execute git log comparisons
# This script handles the common case of comparing current branch with origin/main

set -e

# Default values
FROM_REF="origin/main"
TO_REF="HEAD"
SETUP_SCRIPT_DIR="$(dirname "$0")"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --from)
            FROM_REF="$2"
            shift 2
            ;;
        --to)
            TO_REF="$2"  
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--from <ref>] [--to <ref>]"
            echo "  --from: Source reference (default: origin/main)"
            echo "  --to:   Target reference (default: HEAD)"
            echo "  --help: Show this help message"
            echo
            echo "Examples:"
            echo "  $0                    # Compare origin/main..HEAD"
            echo "  $0 --from main        # Compare main..HEAD"
            echo "  $0 --to feature-branch # Compare origin/main..feature-branch"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo "Preparing to compare ${FROM_REF}..${TO_REF}"

# Try to run git log comparison, but setup git references if it fails
if ! git rev-parse --verify "${FROM_REF}" >/dev/null 2>&1; then
    echo "⚠️  Reference '${FROM_REF}' not found locally"
    echo "Running git setup to fetch required references..."
    
    if [ -f "${SETUP_SCRIPT_DIR}/setup-git.sh" ]; then
        "${SETUP_SCRIPT_DIR}/setup-git.sh"
    else
        echo "setup-git.sh not found, attempting basic fetch..."
        git fetch origin
    fi
fi

# Verify both references exist
if ! git rev-parse --verify "${FROM_REF}" >/dev/null 2>&1; then
    echo "❌ Error: Reference '${FROM_REF}' still not available after setup"
    echo "Available references:"
    git branch -a | head -10
    exit 1
fi

if ! git rev-parse --verify "${TO_REF}" >/dev/null 2>&1; then
    echo "❌ Error: Reference '${TO_REF}' not found"
    exit 1
fi

echo "✅ Both references verified. Running git log comparison..."
echo "Commits in ${TO_REF} that are not in ${FROM_REF}:"
echo "=================================================="

# Execute the git log command
git --no-pager log --oneline "${FROM_REF}..${TO_REF}"