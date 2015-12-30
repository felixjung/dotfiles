# Dotilfes
DOTFILES="$HOME/.dotfiles"

# Define all zsh files
# Taken from Holman's dotfiles
# (https://github.com/holman/dotfiles/tree/master/zsh)
typeset -U config_files
config_files=($DOTFILES/**/*.zsh)

# Load path files
for file in ${${(M)config_files:#*/path.zsh}:#*/*.symlink/*}
do
  source $file
done

# Load alias files
for file in ${${(M)config_files:#*/alias.zsh}:#*/*.symlink/*}
do
  source $file
done

# Load completion
for file in ${${(M)config_files:#*/completion.zsh}:#*/*.symlink/*}
do
  source $file
done

# Load remaining config files
for file in ${${(R)config_files:#*/(path|alias|completion).zsh}:#*/*.symlink/*}
do
  source $file
done

# Source Prezto
PREZTO="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
[[ -s "$PREZTO" ]] && source $PREZTO

# TODO: run this only when on linux!
# export PATH="$HOME/.linuxbrew/bin:$PATH"
# export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
# export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
