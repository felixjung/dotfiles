# Populates $GOROOT and adds a zsh hook to re-configure
# it based on the working directory.
source "$XDG_CONFIG_HOME/asdf/plugins/golang/set-env.zsh"

export GOPATH="$HOME/Development/Go"
export GOFLAGS=""
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
