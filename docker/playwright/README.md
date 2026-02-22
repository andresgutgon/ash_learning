# Playwright Chromium Server (GHCR)

This repository contains a Docker image that runs a **Playwright server** with **Chromium** installed, meant to be used as a remote browser backend (e.g. from `phoenix_test_playwright` in Elixir tests).

The image is published to **GitHub Container Registry (GHCR)** under:

- `ghcr.io/andresgutgon/playwright-chromium:latest`

---

## What this image does

- Installs Playwright OS dependencies for Chromium
- Installs **Playwright-managed Chromium**
- Runs a Playwright server listening on port `3000`

The container exposes the Playwright server WebSocket endpoint, typically:

- `ws://<container-host>:3000`

In docker-compose (service name `playwright`), that becomes:

- `ws://playwright:3000`

---

## Dockerfile location

The Dockerfile lives at:

- `docker/playwright/Dockerfile`

---

## Build the image locally

From the project root:

```bash
docker build \
  -f docker/playwright/Dockerfile \
  -t playwright-chromium:local \
  .
