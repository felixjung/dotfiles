if type brew &>/dev/null; then
  # Remove git completions so hub completions work
  rm -rf $(brew --prefix)/share/zsh/site-functions/_git
fi

