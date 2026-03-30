if status is-interactive
    fish_vi_key_bindings

    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_visual block

    if string match -q -- '*ghostty*' $TERM
        set -g fish_vi_force_cursor 1
    end
end
