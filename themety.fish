function fish_prompt
    set -l short_path (prompt_pwd --full-length-dirs 3)

    set -l git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    set -l git_dirty ""
    if test -n "$git_branch"
        if not git diff --quiet 2>/dev/null; or not git diff --cached --quiet 2>/dev/null
            set git_dirty "*"
        end
    end

    if set -q SSH_CONNECTION
        set sep_color brred
    else
        set -l theme (cat ~/.local/state/theme 2>/dev/null; or echo dark)
        if test "$theme" = light
            set sep_color --bold B4A7C7
        else
            set sep_color --bold white
        end
    end

    set_color red
    printf '%s' $hostname
    set_color $sep_color
    printf ':'
    set_color normal
    set_color blue
    printf '%s' $USER
    set_color $sep_color
    printf ':'
    set_color normal
    set_color yellow
    printf '%s' $short_path
    set_color blue
    printf ' ⇀'
    set_color normal

    if test -n "$git_branch"
        set_color --bold magenta
        printf ' %s%s' $git_branch $git_dirty
        set_color normal
    end

    printf ' '
end
