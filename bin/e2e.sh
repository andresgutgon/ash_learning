#!/usr/bin/env bash
set -euo pipefail

export MIX_ENV=test
export PLAYWRIGHT_WS_ENDPOINT="ws://localhost:3000"

FORCE_ASSETS=0
TEST_ARGS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --force-assets)
      FORCE_ASSETS=1
      shift
      ;;
    *)
      TEST_ARGS+=("$1")
      shift
      ;;
  esac
done

# Default to all feature tests if no specific test provided
if [ ${#TEST_ARGS[@]} -eq 0 ]; then
  TEST_ARGS=("test/e2e/")
fi

assets_built() {
  [[ -f "priv/static/assets/vite_manifest.json" ]] && [[ -f "priv/ssr-js/ssr.js" ]]
}

assets_stale() {
  local manifest="priv/static/assets/vite_manifest.json"
  [[ ! -f "$manifest" ]] && return 0

  # If any common asset source dir has files newer than the manifest, rebuild.
  # Adjust/add dirs if your project differs.
  find assets -type f \
    \( -path 'assets/node_modules/*' -o -path 'assets/.turbo/*' -o -path 'assets/.vite/*' \) -prune -false \
    -o -newer "$manifest" -print -quit 2>/dev/null | grep -q .
}

ssr_link_ok() {
  [[ -L "priv/ssr-js/node_modules" ]] && [[ -d "priv/ssr-js/node_modules" ]]
}

ensure_ssr_symlink() {
  mkdir -p priv/ssr-js

  # If it exists but isn't a symlink, remove it.
  if [[ -e "priv/ssr-js/node_modules" ]] && [[ ! -L "priv/ssr-js/node_modules" ]]; then
    rm -rf priv/ssr-js/node_modules
  fi

  # Create only if missing
  if [[ ! -L "priv/ssr-js/node_modules" ]]; then
    ln -s ../../assets/node_modules priv/ssr-js/node_modules
  fi
}

build_assets() {
  echo "🔧 Building and digesting assets for E2E tests..."
  MIX_ENV=test ./bin/dev assets.deploy
}

# ---- Main ----
if [[ "$FORCE_ASSETS" -eq 1 ]]; then
  echo "🧱 --force-assets enabled"
  build_assets
else
  if assets_built; then
    if assets_stale; then
      echo "⚠️  Built assets detected but stale (running assets.deploy)"
      build_assets
    fi
  else
    echo "⚠️  Built assets not detected (running assets.deploy)"
    build_assets
  fi
fi

if ! ssr_link_ok; then
  echo "🔗 Setting up symlinks for SSR JavaScript dependencies..."
  ensure_ssr_symlink
fi

E2E=true PHX_SERVER=true ./bin/dev test "${TEST_ARGS[@]}"
