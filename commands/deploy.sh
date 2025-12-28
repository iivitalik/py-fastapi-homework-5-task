#!/bin/bash
set -e

handle_error() {
    echo "Error: $1"
    exit 1
}

PROJECT_ROOT="/home/ubuntu/src/py-fastapi-homework-5-ec2-deploy-task"

cd "$PROJECT_ROOT" || handle_error "Failed to navigate to the application directory."

echo "Fetching the latest changes from the remote repository..."
git fetch origin main || handle_error "Failed to fetch updates from the 'origin' remote."

echo "Resetting the local repository to match 'origin/main'..."
git reset --hard origin/main || handle_error "Failed to reset the local repository to 'origin/main'."

echo "Fetching tags from the remote repository..."
git fetch origin --tags || handle_error "Failed to fetch tags from the 'origin' remote."

echo "Stopping old containers and cleaning orphans..."
docker compose -f docker-compose-prod.yml down --remove-orphans || echo "No containers to stop."

echo "Building and running Docker containers..."
docker compose -f docker-compose-prod.yml up -d --build || handle_error "Failed to build and run Docker containers."

echo "Deployment completed successfully."
