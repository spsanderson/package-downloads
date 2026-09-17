#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-package-downloads}"
IMAGE_TAG="${IMAGE_TAG:-local}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

docker build \
  --file "${REPO_ROOT}/.devcontainer/Dockerfile" \
  --tag "${IMAGE_NAME}:${IMAGE_TAG}" \
  "${REPO_ROOT}"

echo
echo "Built ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Test with:"
echo "docker run --rm -it -v \"${REPO_ROOT}:/workspace\" -w /workspace ${IMAGE_NAME}:${IMAGE_TAG} bash"
