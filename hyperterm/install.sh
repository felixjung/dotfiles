#!/usr/local/env bash

hyperterm_dir="$(dirname "$(realpath "$0")")"
source "$hyperterm_dir/../lib/log.sh"
source "$hyperterm_dir/../lib/prompt.sh"

if ! yes_no_prompt "Install hyperterm?"; then
  exit
fi

defaults write com.github.atom ApplePressAndHoldEnabled -bool false

brew cask update
brew cask install hyperterm

if ! yes_no_prompt "Install hyperterm plugins?"; then
  exit
fi

npm install -g hpm-cli
