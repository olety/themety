# Themety

Minimal prompt theme with SSH awareness for zsh, fish, and Claude Code.

![Preview](screenshot.png)

## Features

- `hostname:user:path ⇀` layout
- Git branch + dirty indicator
- SSH-aware separator color (bold white on dark, bold camel on light, bright red over SSH)
- Light/dark theme compatible

## Shell Prompt

### zsh (oh-my-zsh)

```sh
wget -P $ZSH/themes/ https://raw.githubusercontent.com/olety/themety/master/themety.zsh-theme
```

Set in `~/.zshrc`:

```sh
ZSH_THEME="themety"
```

### fish

```sh
cp themety.fish ~/.config/fish/functions/fish_prompt.fish
```

## Claude Code Statusline

Renders the prompt as a Claude Code statusline, reading workspace JSON from stdin.

```sh
cp themety-statusline.sh ~/.claude/themety-statusline.sh
chmod +x ~/.claude/themety-statusline.sh
```

Add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/themety-statusline.sh"
  }
}
```

## Auto Light/Dark Switching

### macOS

Use [claude-theme-sync](https://github.com/alfredomtx/claude-theme-sync) — a lightweight Swift daemon that watches `AppleInterfaceThemeChangedNotification` and updates Claude Code's theme in `~/.claude.json` in real-time. Terminal theme switching depends on your terminal emulator (iTerm2, Ghostty, etc. handle this natively).

```sh
git clone https://github.com/alfredomtx/claude-theme-sync.git
cd claude-theme-sync && ./install.sh
```

Requires Xcode CLI tools (`xcode-select --install`). Runs as a launchd agent — starts on login, restarts on crash.

**Pitfalls:**

- Needs macOS auto appearance enabled: System Settings > Appearance > Auto (or `defaults write -g AppleInterfaceStyleSwitchesAutomatically -bool true`). Without this, macOS never fires the theme change notification.
- Only updates `~/.claude.json` — it does **not** sync your terminal emulator. iTerm2, Ghostty, etc. follow macOS appearance natively via their own settings (e.g. iTerm2: Profiles > Colors > "Use different preset for Light and Dark Mode").
- Rewrites `~/.claude.json` with sorted keys and pretty-print. Shouldn't cause issues but worth knowing if you diff the file.
- The statusline script reads `~/.local/state/theme` for light/dark — claude-theme-sync does **not** write this file (it only writes `~/.claude.json`). On macOS this doesn't matter since the statusline falls back to `dark`, and the separator color difference is subtle. On Linux, `theme-switch` handles this.

### Linux (foot + freedesktop)

`theme-switch` toggles foot terminal (via SIGUSR signals), Claude Code (`~/.claude.json`), and the freedesktop color-scheme (via gsettings) all at once.

```sh
cp theme-switch ~/.local/bin/theme-switch
chmod +x ~/.local/bin/theme-switch
```

Manual usage:

```sh
theme-switch light
theme-switch dark
theme-switch        # auto: light 07:00-19:00, dark otherwise
```

Foot config needs `[colors-light]` and `[colors-dark]` sections plus `initial-color-theme=` in `[main]`. See the [foot wiki](https://codeberg.org/dnkl/foot/wiki) for details.

Optional systemd timers for automatic switching:

`~/.config/systemd/user/theme-light.service`:

```ini
[Unit]
Description=Switch to light theme

[Service]
Type=oneshot
ExecStart=%h/.local/bin/theme-switch light
```

`~/.config/systemd/user/theme-light.timer`:

```ini
[Unit]
Description=Switch to light theme at 07:00

[Timer]
OnCalendar=*-*-* 07:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

Create matching `theme-dark.service` and `theme-dark.timer` (replace `light` with `dark`, `07:00` with `19:00`).

```sh
systemctl --user enable --now theme-light.timer theme-dark.timer
```

## Recommended terminal themes

- Dark: Tomorrow Night Eighties
- Light: Solarized Light
