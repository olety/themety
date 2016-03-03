if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

DIVIDERSIGN=":"

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then DIVIDERCOLOR="cyan"; else DIVIDERCOLOR="white" fi


PROMPT='%{$fg[red]%}%m%{$reset_color%}%{$fg_bold[$DIVIDERCOLOR]%}$DIVIDERSIGN%{$reset_color%}%{$fg[blue]%}%n%{$reset_color%}%{$fg_bold[$DIVIDERCOLOR]%}$DIVIDERSIGN%{$reset_color%}%{$fg[yellow]%}%3~ %{$reset_color%}%{$fg_bold[$CARETCOLOR]%}⇁ %{$reset_color%}'

RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
