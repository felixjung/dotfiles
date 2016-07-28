#!/usr/local/env bash

homebrew_dir="$(dirname "$(realpath "$0")")"
echo $homebrew_dir
source "$homebrew_dir/../lib/log.sh"
source "$homebrew_dir/../lib/prompt.sh"

if ! yes_no_prompt "Install Homebrew? "; then
  exit
fi

os=$(uname -s)

if [ "$os" != "Darwin" ]; then
  fail "Homebrew is only available on macOS. Aborting..."
fi

if yes_no_prompt "Set up Github token for Homebrew?"; then
  user "Enter your Homebrew Github auth token: "
  read -r token
  cp -f "$homebrew_dir/github_token.zsh.example" "$homebrew_dir/github_token.zsh"
  sed -i "" "s/__TOKEN__/$token/g" "$homebrew_dir/github_token.zsh"

  if [ -s ./github_token.zsh ]; then
    source "$homebrew_dir/github_token.zsh"
  fi
fi

# Install Homebrew
if ! type "brew" > /dev/null; then
  info "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  success "Installed Homebrew."
fi

if ! type "brew" > /dev/null; then
  fail "Installing Homebrew failed. Aborting..."
fi

info "Updating formulae..."
brew update
success "Updated formulae."

info "Upgrading formulae..."
brew upgrade
success "Upgraded installed formulae."

info "Tapping into taps..."
source "$homebrew_dir/taps.sh"
success "Tapped all taps."

info "Installing Homebrew formulae..."
source "$homebrew_dir/packages.sh"
success "Installed Homebrew formulae."

info "Installing Homebrew casks..."
source "$homebrew_dir/casks.sh"
success "Installed casks."

success "Successfully installed Homebrew."
exit
