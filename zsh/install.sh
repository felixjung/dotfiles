#!/usr/bin/env bash

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
