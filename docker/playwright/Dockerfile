# Stage 1: Base Playwright installation (rarely changes)
FROM node:22-bookworm-slim AS playwright-base

WORKDIR /home/pw
ARG PW_VERSION=1.58.2

# Create a non-root user for Chromium/Playwright so HOME is stable
RUN groupadd -r pw && useradd -r -g pw -m -d /home/pw pw

# Install OS deps + chromium (Playwright-managed) + CA tools (certutil)
RUN apt-get update && \
    apt-get install -y ca-certificates libnss3-tools && \
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


# Stage 2: Add certificates and final configuration (changes during dev)
FROM playwright-base AS playwright-dev

# Re-declare build args in this stage
ARG PW_VERSION=1.58.2
ARG SKIP_SSL_CERT_CHECK=false

# Copy ONLY what we need: mkcert root CA (public cert)
COPY docker/dev-certificates/rootCA.pem /tmp/rootCA.pem

# Install mkcert root CA into SYSTEM trust + shared NSS
USER root
RUN if [ "$SKIP_SSL_CERT_CHECK" = "true" ]; then \
        echo "WARNING: Skipping SSL certificate validation (SKIP_SSL_CERT_CHECK=true)"; \
        echo "This should only be used in CI or testing environments"; \
        rm -f /tmp/rootCA.pem; \
    else \
        if [ ! -f /tmp/rootCA.pem ]; then \
            echo "ERROR: mkcert root CA not found at docker/dev-certificates/rootCA.pem"; \
            echo "Fix: cp \"\$(mkcert -CAROOT)/rootCA.pem\" docker/dev-certificates/rootCA.pem"; \
            exit 1; \
        fi; \
        \
        # 1) System trust store (Debian/Bookworm)
        cp /tmp/rootCA.pem /usr/local/share/ca-certificates/mkcert-root-ca.crt; \
        update-ca-certificates; \
        \
        # 2) Shared NSS DB (some Chromium builds use this)
        mkdir -p /etc/pki/nssdb; \
        certutil -d "sql:/etc/pki/nssdb" -N --empty-password || true; \
        certutil -d "sql:/etc/pki/nssdb" -A -t "C,," -n "mkcert-root-ca" -i /tmp/rootCA.pem || true; \
        \
        rm -f /tmp/rootCA.pem; \
        echo "mkcert root CA installed for system + shared NSS"; \
    fi

# Install mkcert root CA into USER NSS (covers the other Chromium behavior)
USER pw
RUN if [ "$SKIP_SSL_CERT_CHECK" = "true" ]; then \
        echo "Skipping user NSS install"; \
    else \
        mkdir -p "$HOME/.pki/nssdb"; \
        certutil -d "sql:$HOME/.pki/nssdb" -N --empty-password || true; \
        certutil -d "sql:$HOME/.pki/nssdb" -A -t "C,," -n "mkcert-root-ca" -i /usr/local/share/ca-certificates/mkcert-root-ca.crt || true; \
        echo "mkcert root CA installed for user NSS"; \
    fi

EXPOSE 3000
CMD ["sh", "-c", "npx -y playwright@${PW_VERSION} run-server --port 3000 --host 0.0.0.0"]
