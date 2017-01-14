#!/usr/bin/env bash

atom_dir="$(dirname "$(realpath "$0")")"
source "$atom_dir/../lib/log.sh"
source "$atom_dir/../lib/prompt.sh"

if ! yes_no_prompt "Install starred Atom packages? "; then
  exit
fi

# Disable macOS character accent menu in Atom
defaults write com.github.atom ApplePressAndHoldEnabled -bool false

if ! type "apm" > /dev/null; then
  failure "Could not find apm. Please install it via Atom.app"
fi

apm login
info "Installing starred packages..."
apm stars --install
success "Installed starred packages."
