#!/bin/bash

# Deploy course website - GitHub Actions handles the build

set -e  # Exit on error

echo "Staging changes..."
git add -A

echo "Committing changes..."
git commit -m "Update course website"

echo "Pushing to GitHub..."
git push

echo "Done! GitHub Actions will build and deploy your site."
echo "Check progress at: https://github.com/jaeyk/politics_of_public_policy/actions"
