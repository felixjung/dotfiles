# Easy access to find utility
ff() {
  find . -iname '*$1*'
}
alias ffr='find -E . -iregex '

# Access zsh configuration
alias zshconfig='vim ~/.zshrc'

# System monitoring
alias top-cpu='top -n 10 -o cpu -O time -stats pid,command,cpu,cpu_me,time,threads,ports'

# Create a gif
movToGif() {
  ffmpeg -i $1 -pix_fmt rgb24 -r 24 -f gif - | gifsicle --optimize=2 > $2
}
