#!/usr/bin/env bash
#
# Installs casks via homebrw cask

# $1: desired casks
function brew_cask_inst() {
  local casks="$@"

  # Check for Homebrew
  if type "brew" > /dev/null; then
    printf "Updating Homebrew.\n"
    # Use the latest version of Homebrew
    brew cask update

    printf "Installing desired casks.\n"
    brew cask install $(printf "%s " "${casks[@]}")

    # Remove outdated versions from the Cellar
    printf "Running cleanup.\n"
    brew cask cleanup
  else
    printf "\n"
    printf "Error: Homebrew not found. Run brew.sh first. Aborting...\n"
    exit
  fi
}

#
# Setup casks
#

BREW_CASKS=(
  'superduper'
  'duet'
  'hipchat'
  'omnifocus'
  'dropbox'
  'tunnelblick'
  'atom'
  'atom-shell'
  'alfred'
  'bartender'
  'chatology'
  'cheatsheet'
  'controlplane'
  'iterm2-nightly'
  'xscope'
  'tower'
  'sequel-pro'
  'transmit'
  'kaleidoscope'
  'marked'
  'gitter'
  'font-hack'
)

# Install homebrew casks
brew_cask_inst "${BREW_CASKS[@]}"
