#!/bin/bash

# Script to set up a Minio bucket for Directus
# This script creates a bucket in Minio and configures it for use with Directus
# Uses Docker commands to interact with the Minio container directly

# Use environment variables if set, otherwise use default values
BUCKET_NAME=${MINIO_BUCKET_NAME:-"directus"}
MINIO_ROOT_USER=${MINIO_ROOT_USER:-"minioadmin"}
MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD:-"minioadmin"}

echo "Setting up Minio bucket for Directus..."
echo "Using configuration:"
echo "  Minio Root User: $MINIO_ROOT_USER"
echo "  Minio Root Password: ${MINIO_ROOT_PASSWORD:0:3}*****"
echo "  Bucket Name: $BUCKET_NAME"
echo ""

# Check if the Minio container is running
if ! docker-compose ps | grep -q "minio.*Up"; then
    echo "Minio container is not running. Please start it with 'docker-compose up -d' first."
    exit 1
fi

# Get the Minio container ID
MINIO_CONTAINER=$(docker-compose ps -q minio)
if [ -z "$MINIO_CONTAINER" ]; then
    echo "Could not find Minio container. Please check your docker-compose configuration."
    exit 1
fi

echo "Using Minio container: $MINIO_CONTAINER"

# Create a temporary script to run inside the container
cat > /tmp/minio-setup.sh << EOF
#!/bin/sh
set -e

# Install mc (MinIO Client) if not already installed
if ! command -v mc > /dev/null; then
    echo "Installing MinIO Client (mc)..."
    wget -q https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/bin/mc
    chmod +x /usr/bin/mc
fi

# Configure mc to use our MinIO server
mc alias set myminio http://localhost:9000 $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD

# Create the bucket (will fail silently if it already exists)
echo "Creating bucket '$BUCKET_NAME' (if it doesn't exist)..."
mc mb myminio/$BUCKET_NAME --ignore-existing
echo "Bucket creation step completed."

# Set public read access
echo "Setting public read access for bucket '$BUCKET_NAME'..."
mc anonymous set download myminio/$BUCKET_NAME
echo "Public read access set successfully."
EOF

# Copy the script to the container
docker cp /tmp/minio-setup.sh $MINIO_CONTAINER:/tmp/minio-setup.sh

# Make the script executable and run it
docker exec $MINIO_CONTAINER chmod +x /tmp/minio-setup.sh
docker exec $MINIO_CONTAINER /tmp/minio-setup.sh

# Clean up
rm /tmp/minio-setup.sh
echo ""
echo "Minio bucket setup completed successfully."
