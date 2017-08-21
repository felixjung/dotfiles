#!/usr/bin/env bash

tmux_dir="$(dirname "$(realpath "$0")")"
source "$tmux_dir/../lib/log.sh"
source "$tmux_dir/../lib/prompt.sh"

if ! yes_no_prompt "Set up tmux? "; then
  exit
fi

info "Installing tmuxinator..."
gem install tmuxinator
success "Installed tmuxinator."

info "Installing tmux plugin manager..."
tpm_dir="$HOME/.tmux/plugins"
mkdir -p tpm_dir
git clone https://github.com/tmux-plugins/tpm "$tpm_dir/tpm"
success "Installed tmux plugin manager."
