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
export FZF_DEFAULT_COMMAND='rg --files --hidden --ignore-file ~/.ignore'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --prompt="❯ "
 --color=fg:#959dcb,bg:#292d3e,hl:#82b1ff
 --color=fg+:#bfc7d5,bg+:#292d3e,hl+:#89ddff
 --color=info:#697098,prompt:#c3e88d,pointer:#89ddff
 --color=marker:#ff869a,spinner:#c792ea,header:#ff5370'
