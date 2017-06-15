
# Source zim
if [[ -s ${ZDOTDIR:-${HOME}}/.zim/init.zsh ]]; then
  source ${ZDOTDIR:-${HOME}}/.zim/init.zsh
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

unset config_files

# Set iTerm2 titlebar color
echo -e "\033]6;1;bg;red;brightness;40\a"
echo -e "\033]6;1;bg;green;brightness;44\a"
echo -e "\033]6;1;bg;blue;brightness;52\a"
