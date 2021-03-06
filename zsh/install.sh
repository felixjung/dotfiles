#!/usr/bin/env bash

zsh_dir="$(dirname "$(realpath "$0")")"
source "$zsh_dir/../lib/log.sh"
source "$zsh_dir/../lib/prompt.sh"

if ! yes_no_prompt "Set up ZSH?"; then
  exit
fi

brew install zplug

echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
success "Installed and set up zsh."
