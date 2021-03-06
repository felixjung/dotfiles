# Source splug
if [[ -s $ZPLUG_HOME/init.zsh ]]; then
  source $ZPLUG_HOME/init.zsh
fi

setopt extended_glob

# Define all zsh files
# Taken from Holman's dotfiles
# (https://github.com/holman/dotfiles/tree/master/zsh)
typeset -U config_files
config_files=($DOTFILES/(^(undo|packages|.zim))#/*.zsh)

# Load path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# Load alias files
for file in ${(M)config_files:#*/alias.zsh}
do
  source $file
done

# Load completion
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

# Load remaining config files
for file in ${(R)config_files:#*/(path|alias|completion).zsh}
do
  source $file
done

# TODO: find the right place for this
# Load rbenv automatically by appending
# the following to ~/.zshrc:

eval "$(rbenv init -)"


unset config_files
