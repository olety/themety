PROMPT='%{$fg[red]%}%m%{$reset_color%}%{$fg_bold[white]%}:%{$reset_color%}%{$fg[blue]%}%n%{$reset_color%}%{$fg_bold[white]%}:%{$reset_color%}%{$fg[yellow]%}%3~ %{$reset_color%}%{$fg_bold[blue]%}⇁ %{$reset_color%}'

RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
