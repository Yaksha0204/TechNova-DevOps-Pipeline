#!/bin/bash
# Usage: ./deploy.sh <dockerhub_repo> <image_tag>
set -e

DOCKERHUB_REPO="$1"
IMAGE_TAG="$2"
CONTAINER_NAME="technova_app"

if [ -z "$DOCKERHUB_REPO" ] || [ -z "$IMAGE_TAG" ]; then
  echo "Usage: $0 <dockerhub_repo> <image_tag>"
  exit 2
fi

echo "Deploying ${DOCKERHUB_REPO}:${IMAGE_TAG}"

# Ensure docker is installed (if using user_data this may be already done)
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker not found — installing"
  sudo apt-get update
  sudo apt-get install -y docker.io
  sudo usermod -aG docker $USER
fi

# Pull latest image
sudo docker pull ${DOCKERHUB_REPO}:${IMAGE_TAG}

# Stop existing container (if any)
if sudo docker ps -q --filter "name=${CONTAINER_NAME}" | grep -q .; then
  echo "Stopping running container..."
  sudo docker stop ${CONTAINER_NAME}
  sudo docker rm ${CONTAINER_NAME}
fi

# Run new container
sudo docker run -d --restart unless-stopped --name ${CONTAINER_NAME} \
  -p 80:5000 \
  -e PORT=5000 \
  ${DOCKERHUB_REPO}:${IMAGE_TAG}

echo "Deployed ${DOCKERHUB_REPO}:${IMAGE_TAG} successfully."
