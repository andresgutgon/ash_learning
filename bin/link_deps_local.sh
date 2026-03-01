#!/usr/bin/env bash
set -euo pipefail

mkdir -p deps

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

# Developing dependencies locally.
link vitex
link inertia-phoenix
