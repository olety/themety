#!/bin/bash
# Symlinks all Linux rice configs + shared configs
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

# Shared first
"$REPO/shared/install.sh"

echo "Installing Linux configs..."

# Matugen
mkdir -p ~/.config/matugen/templates
ln -sf "$REPO/linux/matugen/config.toml" ~/.config/matugen/config.toml
for f in "$REPO/linux/matugen/templates/"*; do
  ln -sf "$f" ~/.config/matugen/templates/
done
echo "  matugen config + $(ls "$REPO/linux/matugen/templates/" | wc -l) templates"

# App configs — niri, waybar, eww, gtk-4.0
for app in niri waybar eww gtk-4.0; do
  mkdir -p ~/.config/$app
  for f in "$REPO/linux/$app/"*; do
    [ -f "$f" ] && ln -sf "$f" ~/.config/$app/
  done
done
echo "  niri, waybar, eww, gtk-4.0"

# Ghostty (nested themes/)
mkdir -p ~/.config/ghostty/themes
ln -sf "$REPO/linux/ghostty/config" ~/.config/ghostty/config
for f in "$REPO/linux/ghostty/themes/"*; do
  ln -sf "$f" ~/.config/ghostty/themes/
done
echo "  ghostty + themes"

# Portal config (route Settings to gtk backend for niri)
mkdir -p ~/.config/xdg-desktop-portal
ln -sf "$REPO/linux/xdg-desktop-portal/niri-portals.conf" ~/.config/xdg-desktop-portal/niri-portals.conf
echo "  xdg-desktop-portal config"

# Scripts -> ~/.local/bin/
mkdir -p ~/.local/bin
for f in "$REPO/linux/bin/"*; do
  ln -sf "$f" ~/.local/bin/
done
echo "  $(ls "$REPO/linux/bin/" | wc -l) scripts -> ~/.local/bin/"

echo "Linux install done."
