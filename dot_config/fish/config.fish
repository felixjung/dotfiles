if status --is-interactive
    starship init fish | source

    # Hide greeting message
    set -g fish_greeting
end
