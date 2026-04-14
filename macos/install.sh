#!/bin/bash
# Installs shared configs + macOS theme sync daemon
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Shared first
"$REPO/shared/install.sh"

echo "Installing macOS theme sync..."
"$REPO/macos/install-sync.sh"

echo "macOS install done."
