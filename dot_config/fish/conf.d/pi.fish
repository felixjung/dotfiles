# Run pi through `op run` so 1Password-backed secrets (e.g. NPM_ACCESS_TOKEN,
# and at work the npm registry token) are resolved in the environment — pi shells
# out to `npm` on startup to install its extensions. --no-masking because pi is a
# TUI (matches the codex alias). Provider/model selection is per-machine in
# ~/.pi/agent/settings.json, so this alias is identical on every machine.
alias pi="op run --no-masking -- pi"
