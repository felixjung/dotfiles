#!/usr/bin/env bash

neovim_dir="$(dirname "$(realpath "$0")")"
source "$neovim_dir/../lib/log.sh"
source "$neovim_dir/../lib/prompt.sh"

if ! yes_no_prompt "Set up neovim? "; then
  exit
fi

if ! type "pip3" > /dev/null; then
  pip3 install --user neovim
fi

if ! type "gem" > /dev/null; then
  gem install neovim
fi

# Launch Neovim and install bundles
nvim -u "$neovim_dir/nvim/plugs.vim" +PlugInstall +qa

# Install CoC extensions
vim -c 'CocInstall -sync coc-json coc-html coc-tsserver coc-solargraph coc-rls
coc-yaml coc-highlight coc-snippets coc-vimlsp|q'
