#!/usr/bin/env bash
# Build and run the Docker container for CPU-only inference

# Navigate to repo root
cd "$(dirname "$0")"
cd ..

# Build the Docker image using Dockerfile.cpu
docker build -f docker/Dockerfile.cpu -t jarvis-llama-cpu .

# Run the container (no GPU flags)
docker run -p 8080:8080 \
  -e MODEL_NAME="decapoda-research/llama-7b-hf" \
  --name jarvis-llama-cpu-container \
  jarvis-llama-cpu

echo "Jarvis Llama CPU container started on port 8080."
echo "Try: curl -X POST http://localhost:8080/generate -H \"Content-Type: application/json\" -d '{\"prompt\":\"Hello CPU\"}'"
