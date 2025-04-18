#!/bin/bash

# Script to set up a local development environment for Directus
# This script will:
# 1. Generate secure keys for Directus
# 2. Create a .env file if it doesn't exist
# 3. Launch Directus using docker-compose
# 4. Set up Minio for S3 storage
# 5. Create collections in Directus

# Set script to exit on error
set -e

# Change to the directus directory
cd "$(dirname "$0")"

echo "===== Setting up Directus Development Environment ====="
echo ""

# Step 1: Generate secure keys for Directus
echo "Generating secure keys for Directus..."
source ./generate-keys.sh
echo ""

# Step 2: Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    
    # Update the .env file with the generated keys
    sed -i "s/KEY=replace-with-random-key/KEY=$KEY/" .env
    sed -i "s/SECRET=replace-with-random-secret/SECRET=$SECRET/" .env
    
    # Set a default admin password for development
    # We're keeping the default values from the example.env file
    # sed -i "s/ADMIN_PASSWORD=change-me-please/ADMIN_PASSWORD=admin123/" .env
    # sed -i "s/ADMIN_EMAIL=admin@example.com/ADMIN_EMAIL=admin@alternadevstudio.com/" .env
    
    echo "Environment file created with secure keys."
else
    echo ".env file already exists. Skipping creation."
fi
echo ""

# Step 3: Launch Directus using docker-compose
echo "Launching Directus using docker-compose..."
docker-compose down
docker-compose up -d
echo ""

# Wait for Directus to be ready
echo "Waiting for Directus to be ready..."
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8055/server/health | grep -q "ok"; then
        echo "Directus is ready!"
        break
    fi
    attempt=$((attempt + 1))
    echo "Waiting for Directus to start... ($attempt/$max_attempts)"
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo "Directus failed to start within the expected time."
    echo "Please check the logs with: docker-compose logs directus"
    exit 1
fi
echo ""

# Step 4: Set up Minio for S3 storage
echo "Setting up Minio for Directus..."
./setup-minio-bucket.sh
echo ""

# Step 5: Create collections in Directus
echo "Setting up collections in Directus..."
echo "This will create the following collections:"
echo "- blog_posts"
echo "- projects"
echo "- stream_recap"
echo ""

# Get admin credentials from .env file
ADMIN_EMAIL=$(grep ADMIN_EMAIL .env | cut -d '=' -f2)
ADMIN_PASSWORD=$(grep ADMIN_PASSWORD .env | cut -d '=' -f2)

# Run the setup-collections script from the shared module
echo "Running collection setup script..."
cd ../../
pnpm run directus:setup-collections
cd tools/directus

echo ""
echo "===== Directus Development Environment Setup Complete ====="
echo ""
echo "Directus is running at: http://localhost:8055"
echo "Admin email: $ADMIN_EMAIL"
echo "Admin password: $ADMIN_PASSWORD"
echo ""
echo "The following collections have been created:"
echo "- blog_posts"
echo "- projects"
echo "- stream_recap"
echo ""
echo "You can now use these collections to manage content for your website."
