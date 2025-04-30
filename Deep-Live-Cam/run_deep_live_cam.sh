#!/bin/bash

# Function to check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Error: Docker is not installed"
        exit 1
    fi

    if ! docker info &> /dev/null; then
        echo "Error: Docker daemon is not running"
        exit 1
    fi
}

# Function to check if webcam device exists
check_webcam() {
    if [ ! -c /dev/video0 ]; then
        echo "Warning: Webcam device (/dev/video0) not found"
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Main execution
echo "Starting Deep-Live-Cam setup..."

# Check prerequisites
check_docker
check_webcam

# Build the Docker image
echo "Building Docker image..."
docker build -t deep-live-cam . || {
    echo "Error: Failed to build Docker image"
    exit 1
}

# Run the Docker container
echo "Running Deep-Live-Cam..."
docker run --rm -it \
    --device /dev/video0:/dev/video0 \
    -e DISPLAY=$DISPLAY \
    --name deep-live-cam \
    deep-live-cam

# Cleanup on exit
echo "Cleaning up..."
docker container prune -f
