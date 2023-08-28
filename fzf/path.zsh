
# Filter with ag to respect gitignore
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob=!.git/* --glob=!node_modules/*'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' 
	--color=fg:#c0caf5,bg:#24283b,hl:#bb9af7
	--color=fg+:#c0caf5,bg+:#24283b,hl+:#7dcfff
	--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff 
	--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'
