#!/bin/bash
# Setup script to ensure git log origin/main..HEAD works properly
# This script configures the origin/main remote reference

echo "Setting up git configuration for origin/main reference..."

# Fetch the main branch and set up remote tracking
git fetch origin main:refs/remotes/origin/main 2>/dev/null || {
    echo "Warning: Could not fetch origin/main. Trying alternative setup..."
    git fetch origin main 2>/dev/null || {
        echo "Error: Could not fetch main branch from origin."
        exit 1
    }
}

# Verify the setup works
if git log origin/main..HEAD --oneline >/dev/null 2>&1; then
    echo "✅ Git configuration successful! 'git log origin/main..HEAD' is now working."
else
    echo "❌ Setup failed. Please check your git configuration."
    exit 1
fi