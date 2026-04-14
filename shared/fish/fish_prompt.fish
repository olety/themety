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
        set -l theme (cat ~/.local/state/theme 2>/dev/null)
        if test -z "$theme"
            if command -q defaults
                set theme (defaults read -g AppleInterfaceStyle 2>/dev/null | string lower; or echo light)
            else
                set theme dark
            end
        end
        if test "$theme" = light
            set sep_color --bold C4A57B
        else
            set sep_color --bold white
        end
    end

    # Theme-aware prompt colors
    set -l _theme (cat ~/.local/state/theme 2>/dev/null; or echo dark)
    if test "$_theme" = light
        # Solarized Light
        set -l c_host dc322f    # red
        set -l c_user 268bd2    # blue
        set -l c_path b58900    # yellow (muted amber)
        set -l c_git d33682     # magenta
        set -l c_arrow 268bd2   # blue

        set_color $c_host
        printf '%s' (prompt_hostname)
        set_color $sep_color
        printf ':'
        set_color normal
        set_color $c_user
        printf '%s' $USER
        set_color $sep_color
        printf ':'
        set_color normal
        set_color $c_path
        printf '%s' $short_path

        if test -n "$git_branch"
            set_color $sep_color
            printf ' ('
            set_color --bold $c_git
            printf '%s%s' $git_branch $git_dirty
            set_color $sep_color
            printf ')'
        end

        set_color $c_arrow
        printf ' ⇀'
        set_color normal
    else
        # Tomorrow Night Eighties
        set_color f2777a  # red
        printf '%s' (prompt_hostname)
        set_color $sep_color
        printf ':'
        set_color normal
        set_color 6699cc  # blue
        printf '%s' $USER
        set_color $sep_color
        printf ':'
        set_color normal
        set_color ffcc66  # yellow
        printf '%s' $short_path

        if test -n "$git_branch"
            set_color $sep_color
            printf ' ('
            set_color --bold cc99cc  # magenta
            printf '%s%s' $git_branch $git_dirty
            set_color $sep_color
            printf ')'
        end

        set_color 6699cc  # blue
        printf ' ⇀'
        set_color normal
    end

    printf ' '
end
