# Sets the env vars that depend on the current theme. Cheap and side-effect
# free, so it can run on every shell startup.
function theme_env --argument-names theme
    if [ "$theme" = light ]
        set -gx BAT_THEME "Catppuccin Latte"
        set -gx K9S_SKIN catppuccin-latte-transparent
        set -gx FZF_DEFAULT_OPTS "\
          --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
          --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
          --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
          --color=selected-bg:#BCC0CC \
          --color=border:#9CA0B0,label:#4C4F69"
    else
        set -gx BAT_THEME "Catppuccin Macchiato"
        set -gx K9S_SKIN catppuccin-macchiato-transparent
        set -gx FZF_DEFAULT_OPTS "\
          --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
          --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
          --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
          --color=selected-bg:#494D64 \
          --color=border:#6E738D,label:#CAD3F5"
    end
end

status is-interactive; or return

# fish asks the terminal for its background colour and keeps
# $fish_terminal_color_theme (light, dark or unknown) current. The theme's
# [light] section is Latte, and fish switches sections on its own.
fish_config theme choose catppuccin-macchiato

# $fish_terminal_color_theme is only set once the first prompt is shown, so
# this handler, not startup, seeds the environment for each shell.
function update_theme --on-variable fish_terminal_color_theme
    theme_env $fish_terminal_color_theme

    # Write delta's theme to its own include file rather than --global: the
    # global config is chezmoi-managed, and rewriting it on every theme flip
    # left it permanently dirty in `chezmoi status`.
    set -l delta_theme_file ~/.config/git/delta/current-theme.gitconfig

    if [ "$fish_terminal_color_theme" = light ]
        git config set --file $delta_theme_file delta.features catppuccin-latte
    else
        git config set --file $delta_theme_file delta.features catppuccin-macchiato
    end

    # tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"
end
