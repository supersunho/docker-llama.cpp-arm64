# llama.cpp Docker Image

## What This Is

A Docker image that builds and runs llama.cpp on ARM64 architecture, enabling deployment on devices like Apple Silicon Macs, Raspberry Pi, or ARM-based servers. The image includes OpenSSL support for secure connections.

## Core Value

Provide a ready-to-use Docker container for running llama.cpp inference server on ARM64 platforms with automatic CI/CD builds and GitHub Container Registry deployment.

## Requirements

### Active

- [ ] Dockerfile with Korean comments translated to English
- [ ] GitHub Actions workflow for automatic builds
- [ ] Multi-arch build support (arm64, amd64)
- [ ] Image pushed to ghcr.io on tag push
- [ ] Image pushed to ghcr.io on main branch push

### Out of Scope

- Multi-stage server deployment (single container only)
- GPU support in this version (CPU-only)
- Custom model embedding

## Context

- Existing Dockerfile uses multi-stage build with Ubuntu 22.04
- llama.cpp cloned from ggml-org/llama.cpp repository
- OpenSSL enabled for HTTPS support
- Server exposes port 8080

## Constraints

- **Architecture**: ARM64 (primary), AMD64 (secondary)
- **Registry**: ghcr.io (GitHub Container Registry)
- **Base Image**: Ubuntu 22.04

---

*Last updated: 2026-03-06 after initialization*
