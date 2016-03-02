if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[yellow]%}%m%{$reset_color%}%{$fg_bold[red]%}:%{$reset_color%}%{$fg[cyan]%}%n%{$reset_color%}%{$fg_bold[red]%}:%{$reset_color%}%{$fg[yellow]%}%3~ %{$reset_color%}%{$fg_bold[$CARETCOLOR]%}⇁ %{$reset_color%}'

RPROMPT='$(git_prompt_info)'

#RPS1="$(git_prompt_info)${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"