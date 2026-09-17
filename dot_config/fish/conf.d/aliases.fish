alias top-cpu='top -n 10 -o cpu -O time -stats pid,command,cpu,cpu_me,time,threads,ports'
alias ls='eza'
alias ll='ls -l'
alias tree='ls --tree --level 2'

# Tmux
alias tmuxa='tmux attach-session -t '
alias tmuxl='tmux list-sessions'

# Zellij
abbr -a zja 'zellij attach'
abbr -a zjl 'zellij list-sessions'
abbr -a zjd 'zellij -l dev'
abbr -a zj zellij
# Hand a tab whose name was pinned (by wald, or Ctrl+t r) back to $PWD tracking.
abbr -a ztab-unpin '~/.config/zellij/scripts/zellij-tab-unpin'

# Fish
abbr -a fish-reload-config 'source ~/.config/fish/**/*.fish'

# chezmoi
# Externals (oh-my-zsh, tpm, spaceship-prompt, zsh-syntax-highlighting) are
# upstream dependencies — refresh them via `cmu`, never review them by hand.
abbr -a cma 'chezmoi apply --interactive --exclude=externals'
abbr -a cmu 'chezmoi update'
