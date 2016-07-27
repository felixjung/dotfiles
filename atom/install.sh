#!/usr/bin/env bash

atom_dir="$(dirname "$(realpath "$0")")"
source "$atom_dir/../lib/log.sh"
source "$atom_dir/../lib/prompt.sh"

if ! yes_no_prompt "Install starred Atom packages? "; then
  exit
fi

apm login
info "Installing starred packages..."
apm stars --install
success "Installed starred packages."
