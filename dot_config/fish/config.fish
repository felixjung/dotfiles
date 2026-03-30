if status --is-interactive
    starship init fish | source

    update_theme

    # Hide greeting message
    set -g fish_greeting
end
