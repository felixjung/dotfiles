#!/usr/bin/env bash

# Install python support for neovim
if ! type "pip2" > /dev/null; then
  pip2 install --user neovim
fi

# Install json_pure for Github dashboard plugin.
gem install json_pure

# Launch Neovim and install bundles
nvim -u ./nvim/plugs.vim +PlugInstall +qa
