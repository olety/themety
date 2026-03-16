#!/usr/bin/env bash
set -e

echo "=== Themety Sync Installer ==="

# Check for Xcode CLI tools
if ! command -v swiftc &>/dev/null; then
    echo "Error: swiftc not found. Install Xcode CLI tools: xcode-select --install"
    exit 1
fi

INSTALL_DIR="$HOME/.claude/theme-sync"
PLIST_PATH="$HOME/Library/LaunchAgents/com.claude.theme-sync.plist"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Stop existing daemon
echo "Stopping existing daemon (if any)..."
launchctl bootout "gui/$(id -u)/com.claude.theme-sync" 2>/dev/null || true
pkill -f "themety-sync\|claude-theme-sync" 2>/dev/null || true

# Build
echo "Building..."
mkdir -p "$INSTALL_DIR"
swiftc -O "$SCRIPT_DIR/themety-sync.swift" -o "$INSTALL_DIR/themety-sync"
echo "Built: $INSTALL_DIR/themety-sync"

# Install launchd plist
echo "Installing launch agent..."
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.theme-sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>$INSTALL_DIR/themety-sync</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/themety-sync.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/themety-sync.log</string>
</dict>
</plist>
EOF

# Start daemon
echo "Starting agent..."
launchctl bootstrap "gui/$(id -u)" "$PLIST_PATH"

echo ""
echo "=== Done ==="
echo "themety-sync is running and will start on login."
echo ""
echo "  Status:    launchctl list | grep claude-theme"
echo "  Logs:      tail -f $INSTALL_DIR/themety-sync.log"
echo "  Uninstall: launchctl bootout gui/\$(id -u)/com.claude.theme-sync && rm -rf $INSTALL_DIR $PLIST_PATH"
