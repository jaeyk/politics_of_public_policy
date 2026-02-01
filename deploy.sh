#!/bin/bash

# Build and deploy the course website to GitHub Pages

set -e  # Exit on error

echo "Building Quarto website..."
quarto render

echo "Staging docs folder..."
git add docs

echo "Committing changes..."
git commit -m "Update course website"

echo "Pushing to GitHub..."
git push

echo "Done! Your site will be live shortly at your GitHub Pages URL."
