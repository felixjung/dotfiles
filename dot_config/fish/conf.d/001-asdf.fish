set -gx ASDF_DATA_DIR "$HOME/.asdf"
set -gx ASDF_CONFIG_FILE "$XDG_CONFIG_HOME/asdf/.asdfrc"

# asdf 0.16+ (the Go rewrite) no longer ships a shell script to source.
# Shell integration is now just the shims directory on PATH; completions
# are installed by Homebrew into share/fish/vendor_completions.d.
fish_add_path "$ASDF_DATA_DIR/shims"

# Plugins
if test -f "$ASDF_DATA_DIR/plugins/golang/set-env.fish"
    source "$ASDF_DATA_DIR/plugins/golang/set-env.fish"
end
