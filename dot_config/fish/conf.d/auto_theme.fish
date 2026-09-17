# Sets the env vars that depend on the current theme. Cheap and side-effect
# free, so it can run on every shell startup.
function theme_env --argument-names theme
    if [ "$theme" = light ]
        set -gx BAT_THEME "Catppuccin Latte"
        set -gx FZF_DEFAULT_OPTS "\
          --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
          --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
          --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
          --color=selected-bg:#BCC0CC \
          --color=border:#9CA0B0,label:#4C4F69"
    else
        set -gx BAT_THEME "Catppuccin Macchiato"
        set -gx FZF_DEFAULT_OPTS "\
          --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
          --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
          --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
          --color=selected-bg:#494D64 \
          --color=border:#6E738D,label:#CAD3F5"
    end
end

# $macos_theme is universal, broadcast to every running shell by
# theming/theming.fish. Reacting to it is what universal variables are for.
function update_theme --on-variable macos_theme
    theme_env $macos_theme

    if [ "$macos_theme" = light ]
        fish_config theme choose catppuccin-frappe
        git config set --global delta.features catppuccin-latte
    else
        fish_config theme choose catppuccin-macchiato
        git config set --global delta.features catppuccin-macchiato
    end

    # tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"
end

# The handler above only fires on *change*, and BAT_THEME/FZF_DEFAULT_OPTS are
# per-shell globals now, so seed them for this shell too.
theme_env $macos_theme
