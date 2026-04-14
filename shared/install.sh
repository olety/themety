#!/bin/bash
# Symlinks cross-platform configs (fish prompt, zsh theme, claude statusline)
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing shared configs..."

# Fish
mkdir -p ~/.config/fish/functions ~/.config/fish/conf.d
ln -sf "$REPO/shared/fish/fish_prompt.fish" ~/.config/fish/functions/fish_prompt.fish
ln -sf "$REPO/shared/fish/fish_frozen_theme.fish" ~/.config/fish/conf.d/fish_frozen_theme.fish
echo "  fish prompt + theme"

# ZSH (if oh-my-zsh installed)
if [ -d "$HOME/.oh-my-zsh" ]; then
  ln -sf "$REPO/shared/themety.zsh-theme" ~/.oh-my-zsh/themes/themety.zsh-theme
  echo "  zsh theme"
fi

# Claude Code statusline
mkdir -p ~/.claude
ln -sf "$REPO/shared/themety-statusline.sh" ~/.claude/themety-statusline.sh
echo "  claude statusline"

echo "Shared install done."
