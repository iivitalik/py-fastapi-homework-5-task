#!/bin/bash

set -e

handle_error() {
    echo "Error: $1"
    exit 1
}

PROJECT_DIR="/home/ubuntu/src/py-fastapi-homework-5-ec2-deploy-task"

cd "$PROJECT_DIR" || handle_error "Failed to navigate to $PROJECT_DIR"

echo "Fetching changes..."
git fetch origin main || handle_error "Git fetch failed"

echo "Resetting repository..."
git reset --hard origin/main || handle_error "Git reset failed"

echo "Stopping old containers..."
docker compose -f docker-compose-prod.yml -p theater down || echo "No containers to stop."

echo "Building and running containers..."
docker compose -f docker-compose-prod.yml -p theater up -d --build || handle_error "Docker compose failed"

echo "Deployment completed successfully."
