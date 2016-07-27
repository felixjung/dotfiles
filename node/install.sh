#!/usr/bin/env bash

node_dir="$(dirname "$(realpath "$0")")"
source "$node_dir/../lib/log.sh"
source "$node_dir/../lib/prompt.sh"

if ! yes_no_prompt "Set up npm?"; then
  exit
fi

os=$(uname -s)

npmrc_path="$HOME/.npmrc"
overwrite=0
if [ -f "$npmrc_path" ]; then
  yes_no_prompt "Overwrite existing .npmrc?"
  overwrite="$?"
fi

if [ $overwrite -eq 0 ]; then
  user "Enter your npm access token: "
  read -r token
  cp "$node_dir/npmrc.example" "$node_dir/npmrc"
  if [ "$os" = "Darwin" ]; then
    sed -i "" "s/__TOKEN__/$token/g" "$node_dir/npmrc"
  else
    sed -i"" "s/__TOKEN__/$token/g" "$node_dir/npmrc"
  fi
  mv -f "$node_dir/npmrc" "$npmrc_path"
fi

info "Installing global npm modules"
source "$node_dir/modules.sh"
success "Installed global npm modules."
