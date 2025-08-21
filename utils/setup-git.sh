#!/bin/bash

# setup-git.sh - Setup script to correctly configure git references
# This script ensures that origin/main reference is available for git log comparisons

set -e

echo "Setting up git references..."

# Fetch all refs from origin to ensure we have the latest state
echo "Fetching refs from origin..."
git fetch origin

# Check if origin/main exists in remote refs
if git ls-remote --exit-code origin refs/heads/main >/dev/null 2>&1; then
    echo "✅ origin/main reference is available"
    
    # Check if we have a local tracking branch for main
    if ! git rev-parse --verify origin/main >/dev/null 2>&1; then
        echo "Setting up origin/main tracking reference..."
        git fetch origin main:refs/remotes/origin/main
    fi
    
    echo "✅ Git references setup complete"
else
    echo "⚠️  Warning: No main branch found on origin"
    echo "Available remote branches:"
    git branch -r
fi

echo "Current git status:"
git --no-pager log --oneline -n 3 2>/dev/null || echo "No commits available"
git --no-pager branch -r | head -5