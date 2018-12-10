# EXPORT FZF_HOME
export FZF_HOME=${FZF_HOME:-"$HOME/.fzf"}

# Set up FZF
if [[ -s "$FZF_HOME" ]]; then
  if [[ ! "$PATH" == *"$FZF_HOME"/bin* ]]; then
    export PATH="$PATH:$FZF_HOME/bin"
  fi

  # Man path
  if [[ ! "$MANPATH" == *"$FZF_HOME"/man* && -d "$FZF_HOME/man" ]]; then
    export MANPATH="$MANPATH:$FZF_HOME/man"
  fi
fi

# Filter with ag to respect gitignore
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
