#!/usr/bin/env bash
#
# Installs packages via Homebrew.

# $1: desired homebrew formulae
function brew_pkg_inst() {
  local packages="$@"

  # Check for Homebrew
  if type "brew" > /dev/null; then
    printf "Updating Homebrew.\n"
    # Use the latest version of Homebrew
    brew update

    printf "Upgrading any existing Homebrew formulae.\n"
    # Upgrade any already-installed formulae
    brew upgrade

    printf "Installing desired formulae.\n"
    brew install $(printf "%s " "${packages[@]}")

    # Remove outdated versions from the Cellar
    printf "Running cleanup.\n"
    brew cleanup
  else
    printf "\n"
    printf "Error: Homebrew not found. Aborting...\n"
    exit
  fi
}

# $1: taps
function brew_tap() {
  local taps="$@"

  # Check for Homebrew
  if type "brew" > /dev/null; then
    # Tap into new brew tap
    brew tap $(printf "%s " "${taps[@]}")
    # Remove outdated versions from the Cellar
    brew cleanup
  else
    printf "\n"
    printf "Error: Homebrew not found. Aborting...\n"
    exit
  fi
}

#
# Setup package arrays
#

PKG_MAIN=(
  'git'
  'ack'
  'bash'
  'graphicsmagick'
  'zsh'
  'node'
  'weechat --with-aspell --with-curl --with-perl --with-python --with-ruby --with-lua'
  'unrar'
  'gotags'
  'ctags'
  'python'
  'pango'
  'cairo'
  'fontconfig'
  'tidy-html5',
  'tmux',
  'the_silver_searcher' )

PKG_MAC=(
  'rename'
  'coreutils'
  '--HEAD neovim'
  'reattach-to-user-namespace'
  'caskroom/cask/brew-cask'
  '--HEAD choppsv1/term24/vim --override-system-vi --without-nls' )

PKG_LINUX=(
  'vim --override-system-vi --without-nls' )

#
# Setup taps
#

BREW_TAPS=(
  'caskroom/versions'
  'caskroom/fonts'
  'homebrew/versions'
  'neovim/neovim'
  'choppsv1/term24'
)

# Tap
brew_tap "${BREW_TAPS[@]}"

# Install main homebrew packages
brew_pkg_inst "${PKG_MAIN[@]}"

# Install platform specific packages
if [[ "$(uname -s)" = "Darwin" ]]; then
  # Install homebrew packages for OS X
  brew_pkg_inst "${PKG_MAC[@]}"
else
  # Install linuxbrew packages
  brew_pkg_inst "${PKG_LINUX[@]}"
fi
