#!/bin/bash
set -e

echo "Starting Playwright server..."

# If SSL certificate file is mounted, install it at runtime
if [ -f "/tmp/ssl/rootCA.pem" ]; then
    echo "Installing SSL certificate from mounted file..."

    # Create NSS databases for Chromium certificate trust
    for nss_dir in "$HOME/.pki/nssdb" "$HOME/.local/share/nssdb"; do
        echo "Processing NSS database: $nss_dir"
        mkdir -p "$nss_dir"
        
        # Try to create NSS database, but don't fail if it already exists
        if ! certutil -d "sql:$nss_dir" -L >/dev/null 2>&1; then
            echo "Creating NSS database in $nss_dir..."
            if ! certutil -d "sql:$nss_dir" -N --empty-password 2>/dev/null; then
                echo "⚠ Failed to create NSS database in $nss_dir, skipping"
                continue
            fi
        fi
        
        # Install certificate if not already present
        if ! certutil -d "sql:$nss_dir" -L -n "root-ca" >/dev/null 2>&1; then
            echo "Installing certificate in $nss_dir..."
            if certutil -d "sql:$nss_dir" -A -t "TCu,Cu,Tu" -n "root-ca" -i /tmp/ssl/rootCA.pem 2>/dev/null; then
                echo "✓ Certificate installed in $nss_dir"
            else
                echo "⚠ Failed to install certificate in $nss_dir"
            fi
        else
            echo "✓ Certificate already exists in $nss_dir"
        fi
    done

    # Set environment variables for certificate trust
    export NODE_EXTRA_CA_CERTS=/tmp/ssl/rootCA.pem
    export SSL_CERT_FILE=/tmp/ssl/rootCA.pem
    export SSL_CERT_DIR=/tmp/ssl

    # Verify the certificate chain if cert.pem exists
    if [ -f "/tmp/ssl/cert.pem" ]; then
        echo "Verifying SSL certificate installation..."
        if openssl verify -CAfile /tmp/ssl/rootCA.pem /tmp/ssl/cert.pem >/dev/null 2>&1; then
            echo "✓ Certificate verification successful"
        else
            echo "⚠ Certificate verification failed - but continuing..."
        fi
    fi

    # Test NSS certificate installation
    if certutil -d "sql:$HOME/.pki/nssdb" -L 2>/dev/null | grep -q "root-ca"; then
        echo "✓ Certificate found in NSS database"
    else
        echo "⚠ Certificate not found in NSS database"
    fi

    echo "SSL certificate installation completed"
else
    echo "No SSL certificate found at /tmp/ssl/rootCA.pem - continuing without SSL"
fi

# Start Playwright server
echo "Starting Playwright server on port 3000..."
exec npx playwright run-server --port 3000 --host 0.0.0.0
