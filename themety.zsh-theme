if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

PROMPT='%{$fg[yellow]%}%m%{$reset_color%}%{$fg_bold[blue]%}:%{$reset_color%}%{$fg[cyan]%}%n%{$reset_color%}%{$fg_bold[blue]%}:%{$reset_color%}%{$fg[yellow]%}%3~ %{$reset_color%}%{$fg_bold[$CARETCOLOR]%}⇁ %{$reset_color%}'

RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
