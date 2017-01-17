#!/usr/local/env bash

hyper_dir="$(dirname "$(realpath "$0")")"
source "$hyper_dir/../lib/log.sh"
source "$hyper_dir/../lib/prompt.sh"

if ! yes_no_prompt "Install Hyper?"; then
  exit
fi

defaults write co.zeit.hyper ApplePressAndHoldEnabled -bool false

brew cask update
brew cask install hyperterm

if ! yes_no_prompt "Install hyper plugins?"; then
  exit
fi

npm install -g hpm-cli
