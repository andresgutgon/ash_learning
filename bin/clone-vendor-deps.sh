#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Vendor Dependencies Configuration
# Format: "owner/repo:branch:target_dir"
# =============================================================================
VENDOR_DEPS=(
  "andresgutgon/inertia-phoenix:feature/inertia-vitejs-integration:inertia-phoenix"
  "andresgutgon/vitex:main:vitex"
)

# =============================================================================
# Script
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VENDOR_DIR="$PROJECT_ROOT/vendor"
DEPS_DIR="$PROJECT_ROOT/deps"

echo "Cloning vendor dependencies into $VENDOR_DIR"

mkdir -p "$VENDOR_DIR"
mkdir -p "$DEPS_DIR"

for dep in "${VENDOR_DEPS[@]}"; do
  IFS=':' read -r repo branch target_dir <<< "$dep"
  vendor_path="$VENDOR_DIR/$target_dir"
  deps_path="$DEPS_DIR/$target_dir"

  # Clone into vendor/
  if [ -d "$vendor_path" ]; then
    echo "  ✓ vendor/$target_dir already exists, skipping clone"
  else
    echo "  → Cloning $repo ($branch) into vendor/$target_dir"
    git clone --depth 1 --branch "$branch" "https://github.com/$repo.git" "$vendor_path"
    echo "  ✓ vendor/$target_dir cloned"
  fi

  # Create symlink in deps/ (Mix doesn't do this for path deps)
  if [ -L "$deps_path" ]; then
    echo "  ✓ deps/$target_dir symlink already exists"
  elif [ -d "$deps_path" ]; then
    echo "  ⚠ deps/$target_dir is a directory, removing and creating symlink"
    rm -rf "$deps_path"
    ln -s "$vendor_path" "$deps_path"
    echo "  ✓ deps/$target_dir symlink created"
  else
    ln -s "$vendor_path" "$deps_path"
    echo "  ✓ deps/$target_dir symlink created"
  fi
done

echo "Done!"
