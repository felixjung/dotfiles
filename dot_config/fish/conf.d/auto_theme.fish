function update_theme --on-variable macos_theme
    if [ "$macos_theme" = dark ]
        fish_config theme choose catppuccin-macchiato
        set -Ux BAT_THEME "Capppuccin Macchiato"
        set -Ux FZF_DEFAULT_OPTS "\
          --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
          --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
          --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
          --color=selected-bg:#494D64 \
          --color=border:#6E738D,label:#CAD3F5"
        git config set --global delta.features catppuccin-macchiato
    else if [ "$macos_theme" = light ]
        fish_config theme choose catppuccin-frappe
        set -Ux BAT_THEME "Catppuccin Latte"
        set -Ux FZF_DEFAULT_OPTS "\
          --color=bg+:#CCD0DA,bg:#EFF1F5,spinner:#DC8A78,hl:#D20F39 \
          --color=fg:#4C4F69,header:#D20F39,info:#8839EF,pointer:#DC8A78 \
          --color=marker:#7287FD,fg+:#4C4F69,prompt:#8839EF,hl+:#D20F39 \
          --color=selected-bg:#BCC0CC \
          --color=border:#9CA0B0,label:#4C4F69"
        git config set --global delta.features catpuccin-latte
    end

    # tmux source-file "$XDG_CONFIG_HOME/tmux/tmux.conf"
end
