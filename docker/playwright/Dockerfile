# Stage 1: Base Playwright installation (rarely changes)
FROM node:22-bookworm-slim AS playwright-base

WORKDIR /home/pw
ARG PW_VERSION=1.58.2

# Create a non-root user for Chromium/Playwright so HOME is stable
RUN groupadd -r pw && useradd -r -g pw -m -d /home/pw pw

# Install OS deps + chromium (Playwright-managed) + CA tools (certutil) + openssl
RUN apt-get update && \
    apt-get install -y ca-certificates libnss3-tools openssl && \
    npx -y playwright@${PW_VERSION} install-deps chromium && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN npx -y playwright@${PW_VERSION} install chromium

# Make sure pw can read browser files + owns its home
RUN chown -R pw:pw /home/pw /ms-playwright

# Run as pw from here on
USER pw
ENV HOME=/home/pw


# Stage 2: Add certificates and final configuration
FROM playwright-base AS playwright-dev

# Re-declare build args in this stage
ARG PW_VERSION=1.58.2

EXPOSE 3000

# Copy and setup entrypoint script
COPY docker/playwright/entrypoint.sh /home/pw/entrypoint.sh

# Make entrypoint executable and set proper ownership
USER root
RUN chmod +x /home/pw/entrypoint.sh && chown pw:pw /home/pw/entrypoint.sh
USER pw

CMD ["/home/pw/entrypoint.sh"]
