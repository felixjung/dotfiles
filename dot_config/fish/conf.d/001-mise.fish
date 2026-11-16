# Homebrew's vendor activation runs later. Activate once here, including shims
# for tools launched by noninteractive Fish commands.
fish_add_path --path "$HOME/.local/share/go/bin"

set -l mise_bin (command -s mise)
if test -z "$mise_bin"
    # Homebrew's conf.d may not have added its bin directory yet.
    for candidate in /opt/homebrew/bin/mise /home/linuxbrew/.linuxbrew/bin/mise
        if test -x "$candidate"
            set mise_bin "$candidate"
            break
        end
    end
end
if test -n "$mise_bin"
    set -gx MISE_FISH_AUTO_ACTIVATE 0
    if status is-interactive
        "$mise_bin" activate fish | source
    else
        set -l mise_data_home "$HOME/.local/share"
        if set -q XDG_DATA_HOME; and test -n "$XDG_DATA_HOME"
            set mise_data_home "$XDG_DATA_HOME"
        end
        fish_add_path --path --move "$mise_data_home/mise/shims"
    end
end
