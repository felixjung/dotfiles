# Check if ** completion pattern exists
[[ $- == *i* && -s "$FZF_HOME" ]] && source "$FZF_HOME/shell/completion.zsh" 2> /dev/null
