alias top-cpu='top -n 10 -o cpu -O time -stats pid,command,cpu,cpu_me,time,threads,ports'
alias ls='eza'
alias ll='ls -l'
alias tree='ls --tree --level 2'

# Tmux
alias tmuxa='tmux attach-session -t '
alias tmuxl='tmux list-sessions'

# Fish
abbr -a fish-reload-config 'source ~/.config/fish/**/*.fish'
