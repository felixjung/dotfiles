#!/usr/bin/env bash
#

# Prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

# Make zsh the default shell
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
