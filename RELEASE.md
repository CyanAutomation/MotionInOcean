# motion-in-ocean 🌊📷  
**Raspberry Pi CSI Camera Streaming in Docker (Picamera2 / libcamera)**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Docker Image](https://img.shields.io/badge/GHCR-motion--in--ocean-informational)](https://github.com/<your-org-or-user>/motion-in-ocean/pkgs/container/motion-in-ocean)
[![Build](https://img.shields.io/badge/build-GitHub_Actions-lightgrey)](#ci--cd)
[![Status](https://img.shields.io/badge/status-alpha-orange)](#project-status)

motion-in-ocean is a **Docker-first** project for running a **Raspberry Pi CSI camera** inside a container and streaming video across the network. It’s intended for **Raspberry Pi homelabs** and remote Docker hosts, where you want a reliable camera stream without installing a full stack directly on the host OS.

This repo is a fork of `hyzhak/pi-camera-in-docker`, with the goal of making the solution more polished and **“homelab deployable”**:

- build the image once
- publish to GHCR
- deploy from a `docker-compose.yml` that pulls an image tag (no local builds required)

---

## Quick Start (Recommended)

> ✅ **Target:** Raspberry Pi OS (64-bit) / Debian Bookworm on ARM64  
> ✅ **Assumption:** CSI camera enabled and working on the host  
> ✅ **Usage:** Homelab LAN / VLAN only (do not expose directly to the internet)

### 1) Create folder + config

```bash
mkdir -p ~/containers/motion-in-ocean
cd ~/containers/motion-in-ocean

curl -fsSL https://raw.githubusercontent.com/<your-org-or-user>/motion-in-ocean/main/.env.example -o .env
nano .env
