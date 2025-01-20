#!/usr/bin/env bash
#
# Build and run the Docker container with GPU support for Llama inference.
# Requires an x86_64 machine with an NVIDIA GPU and the NVIDIA Container Toolkit.
#
# Usage:
#   ./build_and_run_gpu.sh

# 1. Navigate to the repository root (assuming this script is in scripts/).
cd "$(dirname "$0")"
cd ..

# 2. Build the Docker image using Dockerfile.gpu in the docker/ directory.
#    We'll tag the image as jarvis-llama-gpu.
docker build \
  -f docker/Dockerfile.gpu \
  -t jarvis-llama-gpu .

# 3. Run the container with GPU pass-through.
#    - Maps host port 8080 to container port 8080
#    - Sets the MODEL_NAME environment variable to load a specific HF model
#    - Names the container jarvis-llama-gpu-container
docker run --gpus all -d \
  -p 8080:8080 \
  -e MODEL_NAME="decapoda-research/llama-7b-hf" \
  --name jarvis-llama-gpu-container \
  jarvis-llama-gpu

echo "========================================="
echo "Jarvis Llama GPU container is running!"
echo "Container Name: jarvis-llama-gpu-container"
echo "Listening on port 8080 for inference."
echo
echo "Try testing the endpoint with a curl command:"
echo "curl -X POST http://localhost:8080/generate \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"prompt\":\"Hello GPU\",\"max_new_tokens\":30}'"
echo "========================================="
