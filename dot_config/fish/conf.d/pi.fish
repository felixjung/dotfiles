# Run pi through `op run` so 1Password-backed secrets (e.g. NPM_ACCESS_TOKEN,
# and at work the npm registry token) are resolved in the environment — pi shells
# out to `npm` on startup to install its extensions. --no-masking because pi is a
# TUI (matches the codex alias). Provider/model selection is per-machine in
# ~/.pi/agent/settings.json, so this alias is identical on every machine.
# agent_identity gives pi its own signing key and GitHub token, so it can commit,
# push and use `gh` while 1Password is locked.
alias pi="agent_identity op run --no-masking -- pi"

# Give the agent the `plannotator` tool (annotate/review with an approval gate);
# the documents skill's review gate depends on it.
set -gx PLANNOTATOR_AGENT_TOOL 1
