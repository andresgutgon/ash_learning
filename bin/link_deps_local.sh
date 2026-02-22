#!/usr/bin/env bash
set -euo pipefail

mkdir -p deps

# Create symlink for fonts in development
link_fonts() {
  local src="assets/static/fonts"
  local dst="priv/static/fonts"
  
  # Create priv/static directory if it doesn't exist
  mkdir -p "priv/static"
  
  # Remove existing fonts directory/symlink
  rm -rf "$dst"
  
  # Create symlink
  ln -s "../../$src" "$dst"
  echo "linked $dst -> $src"
}

# This is necessary to have local linked dependencies work
# with `deps` in the root of the project, which is where mix expects them.
# For example vitex exports a `js` module that is used by inertia-phoenix,
#
# import vitexPlugin from '../deps/vitex/priv/vitejs/vitePlugin.js'
# Local installed depencencies are symlinked to the `deps` folder, so that they can be imported as if they were installed from hex.
link() {
  local folder="$1"
  local src="$HOME/code/opensource/$folder"
  local dst="deps/$folder"

  [ -d "$src" ] || { echo "Missing $src"; exit 1; }

  rm -rf "$dst"
  ln -s "$src" "$dst"
  echo "linked $dst -> $src"
}

# Link fonts for development
link_fonts

# Developing dependencies locally.
link vitex
link inertia-phoenix
