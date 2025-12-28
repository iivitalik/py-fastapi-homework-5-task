#!/bin/bash

set -e

handle_error() {
    echo "Error: $1"
    exit 1
}

PROJECT_DIR="/home/ubuntu/src/py-fastapi-homework-5-ec2-deploy-task"

cd "$PROJECT_DIR" || handle_error "Failed to navigate to the application directory."

echo "Fetching the latest changes..."
git fetch origin main || handle_error "Failed to fetch updates."

echo "Resetting to origin/main..."
git reset --hard origin/main || handle_error "Failed to reset."

echo "Fetching tags..."
git fetch origin --tags || handle_error "Failed to fetch tags."

echo "Stopping old containers to avoid conflicts..."
docker compose -f docker-compose-prod.yml down || echo "No containers to stop."

echo "Building and running containers..."
docker compose -f docker-compose-prod.yml up -d --build || handle_error "Failed to build containers."

echo "Deployment completed successfully."
