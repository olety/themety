# Theme-aware fish colors: Tomorrow Night Eighties (dark) / Solarized (light)
# Reads ~/.local/state/theme at shell startup

set -l _theme (cat ~/.local/state/theme 2>/dev/null; or echo dark)

if test "$_theme" = light
    # Solarized Light
    set --global fish_color_autosuggestion 93a1a1
    set --global fish_color_cancel -r
    set --global fish_color_command 586e75
    set --global fish_color_comment 93a1a1
    set --global fish_color_cwd b58900
    set --global fish_color_cwd_root dc322f
    set --global fish_color_end 859900
    set --global fish_color_error dc322f
    set --global fish_color_escape 2aa198
    set --global fish_color_history_current --bold
    set --global fish_color_host 657b83
    set --global fish_color_host_remote cb4b16
    set --global fish_color_normal 657b83
    set --global fish_color_operator 2aa198
    set --global fish_color_param 2aa198
    set --global fish_color_quote b58900
    set --global fish_color_redirection 6c71c4 --bold
    set --global fish_color_search_match --background=eee8d5
    set --global fish_color_selection --bold --background=eee8d5
    set --global fish_color_status dc322f
    set --global fish_color_user 268bd2
    set --global fish_color_valid_path --underline
    set --global fish_pager_color_completion 657b83
    set --global fish_pager_color_description b58900 -i
    set --global fish_pager_color_prefix 268bd2 --bold --underline
    set --global fish_pager_color_progress fdf6e3 --background=268bd2
    set --global fish_pager_color_selected_background -r
else
    # Tomorrow Night Eighties
    set --global fish_color_autosuggestion 999999
    set --global fish_color_cancel -r
    set --global fish_color_command cccccc
    set --global fish_color_comment f2777a
    set --global fish_color_cwd 99cc99
    set --global fish_color_cwd_root f2777a
    set --global fish_color_end 99cc99
    set --global fish_color_error f2777a
    set --global fish_color_escape 66cccc
    set --global fish_color_history_current --bold
    set --global fish_color_host cccccc
    set --global fish_color_host_remote ffcc66
    set --global fish_color_normal cccccc
    set --global fish_color_operator 66cccc
    set --global fish_color_param 66cccc
    set --global fish_color_quote ffcc66
    set --global fish_color_redirection 66cccc --bold
    set --global fish_color_search_match ffffff --background=999999
    set --global fish_color_selection ffffff --bold --background=999999
    set --global fish_color_status f2777a
    set --global fish_color_user 99cc99
    set --global fish_color_valid_path --underline
    set --global fish_pager_color_completion cccccc
    set --global fish_pager_color_description ffcc66 -i
    set --global fish_pager_color_prefix cccccc --bold --underline
    set --global fish_pager_color_progress ffffff --background=66cccc
    set --global fish_pager_color_selected_background -r
end
