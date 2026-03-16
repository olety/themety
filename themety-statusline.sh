#!/usr/bin/env bash

input=$(cat)

hostname=$(cat /etc/hostname 2>/dev/null || hostname -s)
username=${USER:-$(id -un)}

cwd=$(echo "$input" | grep -o '"current_dir":"[^"]*"' | head -1 | sed 's/"current_dir":"//;s/"$//')

if [ -z "$cwd" ]; then
    cwd="$PWD"
fi

get_short_path() {
    local path="$1"
    local home="$HOME"

    if [[ "$path" == "$home" ]]; then
        echo "~"
        return
    fi

    if [[ "$path" == "$home"/* ]]; then
        path="~${path#$home}"
    fi

    IFS='/' read -ra parts <<< "$path"
    local count=${#parts[@]}

    if [ $count -le 3 ]; then
        echo "$path"
    else
        local start=$((count - 3))
        local result=""
        for i in $(seq $start $((count - 1))); do
            if [ -n "${parts[$i]}" ]; then
                if [ -z "$result" ]; then
                    result="${parts[$i]}"
                else
                    result="${result}/${parts[$i]}"
                fi
            fi
        done
        echo "$result"
    fi
}

short_path=$(get_short_path "$cwd")

git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
git_status=""
if [ -n "$git_branch" ]; then
    if ! git -C "$cwd" diff --quiet 2>/dev/null || ! git -C "$cwd" diff --cached --quiet 2>/dev/null; then
        git_status="*"
    fi
fi

if [ -n "$SSH_CONNECTION" ]; then
    sep="\033[1;31m"
else
    theme=$(cat "${XDG_STATE_HOME:-$HOME/.local/state}/theme" 2>/dev/null)
    if [ -z "$theme" ]; then
        if command -v defaults >/dev/null 2>&1; then
            theme=$(defaults read -g AppleInterfaceStyle 2>/dev/null | tr '[:upper:]' '[:lower:]' || echo light)
        else
            theme=$(grep -o '"theme" *: *"[^"]*"' ~/.claude.json 2>/dev/null | sed 's/.*"theme" *: *"//;s/"//')
            : "${theme:=dark}"
        fi
    fi
    if [ "$theme" = "light" ]; then
        sep="\033[1;38;2;196;165;123m"
    else
        sep="\033[1;37m"
    fi
fi

printf "\033[31m%s${sep}:\033[0;34m%s${sep}:\033[0;33m%s \033[34m⇀\033[0m" "$hostname" "$username" "$short_path"

if [ -n "$git_branch" ]; then
    printf " \033[1;35m%s%s\033[0m" "$git_branch" "$git_status"
fi
