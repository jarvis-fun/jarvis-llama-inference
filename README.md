# Jarvis Llama Inference


This repository provides two Dockerfiles for running Llama (or Llama 2) in a **Docker** container:
- **GPU Version**: Uses an NVIDIA CUDA base image for **GPU-accelerated** inference (x86_64 + NVIDIA GPU).
- **CPU Version**: Uses a plain Ubuntu base image for **CPU-only** inference, suitable for quick tests or Apple Silicon fallback.

### Dockerfile.gpu
- Based on `nvidia/cuda:11.8.0-devel-ubuntu22.04`.
- Installs PyTorch with CUDA 11.8 support (`torch==2.0.1+cu118`, etc.).
- Requires an x86_64 environment with NVIDIA drivers and the **NVIDIA Container Toolkit** installed.

### Dockerfile.cpu
- Based on `ubuntu:22.04`.
- Installs **CPU-only** PyTorch wheels.
- Suitable for local testing or Apple Silicon Docker (ARM), though inference will be slower.

---

## Why We Built This

Within **Jarvis**, we frequently need natural-language processing and generative AI to:
- Interpret user instructions (“Buy SOL if RSI < 30…”).
- Generate human-like responses for trading insights or DeFi management tasks.
- Rapidly prototype AI-driven features without reconfiguring GPU servers.

By bundling Llama in a **Docker** container, we simplify setup and ensure consistent deployments across development, staging, and production.

---

## Where We Are Using It

- **Jarvis Core**: Primary inference engine for prompt-based instructions, turning plain-English commands into structured actions.
- **DeFi Management**: Automated liquidity provisioning and yield-farming instructions via Raydium or other protocols.
- **Internal Tools**: Prototyping and testing new AI-driven components quickly and reliably.

---

## Quick Start

1. **Requirements**:
   - An x86_64 machine with an NVIDIA GPU (local or cloud).
   - [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) installed.
   
2. **Build & Run**:
   ```bash
   cd scripts
   ./build_and_run_gpu.sh
 
3. **Test the endpoint:**
   ```bash
    curl -X POST http://localhost:8080/generate \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Hello, Jarvis!", "max_new_tokens": 30}'
    ```



