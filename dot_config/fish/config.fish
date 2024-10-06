if status --is-interactive
    starship init fish | source

    update_theme

    fish_vi_key_bindings

    # Hide greeting message
    set -g fish_greeting
end
