# Set GOROOT and GOPATH
# export GOROOT="/opt/homebrew/opt/go/libexec"
export GOPATH="$HOME/Development/Go"
source ~/.asdf/plugins/golang/set-env.zsh
export GOFLAGS=""
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

