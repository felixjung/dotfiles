#!/usr/bin/env bash

zsh_dir="$(dirname "$(realpath "$0")")"
source "$zsh_dir/../lib/log.sh"
source "$zsh_dir/../lib/prompt.sh"

info "Installing prezto..."
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
success "Installed and set up zsh."
