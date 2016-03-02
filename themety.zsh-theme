if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[yellow]%}%m%{$reset_color%}%{$fg_bold[blue]%}:%{$reset_color%}%{$fg[cyan]%}%n%{$reset_color%}%{$fg_bold[blue]%}:%{$reset_color%}%{$fg[yellow]%}%3~ %{$reset_color%}%{$fg_bold[blue]%}⇁ %{$reset_color%}'



RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"