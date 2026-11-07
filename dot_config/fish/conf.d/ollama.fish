# Start the local API server managed by Homebrew.
alias ollama-start='brew services start ollama'

# Run one model at a time on this 64GB Mac. Arguments after an alias are passed
# to `ollama run`, so both interactive chat and one-shot prompts work.
alias ollama-code='ollama run qwen3.6:35b-mlx'
alias ollama-meetings='ollama run qwen3.8:27b-mlx'
alias ollama-fast='ollama run gemma4:12b-mlx'
