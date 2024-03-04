
set -U ASDF_DATA_DIR "$HOME/.asdf"
set -U ASDF_CONFIG_FILE "$XDG_CONFIG_HOME/asdf/.asdfrc"

# Load asdf plugin
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# Plugins
source ~/.asdf/plugins/golang/set-env.fish

go env -w GOPATH=(asdf where golang)/packages

set -gx GOROOT (go env GOROOT)
set -gx GOPATH (go env GOPATH)
