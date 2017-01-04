# Add npm's binaries to $PATH
export NODE_PATH="/usr/local/lib/node_modules/"
export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"
export PATH="$PATH:`yarn global bin`"
