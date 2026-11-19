#!/usr/bin/env bash
set -euo pipefail
echo "Building and installing JuiceBar for macOS..."
make install
xattr -cr /Applications/JuiceBar.app 2>/dev/null || true
open /Applications/JuiceBar.app
echo "✅ JuiceBar is now running in your macOS menu bar!"
