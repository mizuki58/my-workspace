#!/bin/bash

# Store the workspace path in a variable
WORKSPACE_DIR="${HOME}/workspace"

echo "Setting up git configurations..."

echo "Current directory: $(pwd)"

# Change to the workspace directory
cd "${WORKSPACE_DIR}" || { echo "Failed to change directory to ${WORKSPACE_DIR}"; exit 1; }

# Set commit template and hooks path
git config --global --add safe.directory ${WORKSPACE_DIR}
git config commit.template "${WORKSPACE_DIR}/.devcontainer/docker/workspace/git/commitTemplate.txt" || { echo "Failed to set commit template"; exit 1; }
git config core.hooksPath "${WORKSPACE_DIR}/.devcontainer/docker/workspace/git/.githooks" || { echo "Failed to set hooks path"; exit 1; }

# Make the pre-commit hook executable
chmod +x "${WORKSPACE_DIR}/.devcontainer/docker/workspace/git/.githooks/pre-commit" || { echo "Failed to make pre-commit hook executable"; exit 1; }

echo "Git configuration completed successfully."