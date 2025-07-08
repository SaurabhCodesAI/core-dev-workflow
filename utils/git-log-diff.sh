#!/bin/bash
# Git log helper script that ensures origin/main reference is available
# Usage: ./git-log-diff.sh [additional git log options]

# Check if origin/main reference exists
if ! git rev-parse origin/main >/dev/null 2>&1; then
    echo "Setting up origin/main reference..."
    
    # Try to fetch and set up origin/main
    if ! git fetch origin main:refs/remotes/origin/main 2>/dev/null; then
        echo "Warning: Could not set up origin/main reference automatically."
        echo "Please run: git fetch origin main:refs/remotes/origin/main"
        exit 1
    fi
    
    echo "✅ Origin/main reference set up successfully."
fi

# Run the git log command with any additional arguments
echo "Showing commits in current branch that are not in origin/main:"
echo "================================================"
git log origin/main..HEAD "$@"