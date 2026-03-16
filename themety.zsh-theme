if [[ -n "$SSH_CONNECTION" ]]; then
  _themety_sep="%B%F{red}"
else
  _themety_theme=$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/theme" 2>/dev/null)
  if [[ -z "$_themety_theme" ]]; then
    if command -v defaults &>/dev/null; then
      _themety_theme=$(defaults read -g AppleInterfaceStyle 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo light)
    else
      _themety_theme=dark
    fi
  fi
  if [[ "$_themety_theme" == "light" ]]; then
    _themety_sep="%B%F{#C4A57B}"
  else
    _themety_sep="%B%F{white}"
  fi
  unset _themety_theme
fi

PROMPT='%F{red}%m${_themety_sep}:%f%F{blue}%n${_themety_sep}:%f%F{yellow}%3~ %F{blue}⇀ %f'

RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%F{magenta}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%f"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
