#!/usr/bin/env bash

# Install python support
if ! type "pip2" > /dev/null; then
  pip2 install --user neovim
fi

# Launch Neovim and install bundles
vim -u ~/.nvim/plugs.vim +PlugInstall +qa

# json_pure is required for Github dashboard.
gem install json_pure
