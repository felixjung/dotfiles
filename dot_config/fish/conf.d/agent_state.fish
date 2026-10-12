# Prune coding-agent status files left by agents that were killed without
# reporting an end. Runs outside Zellij too, so WezTerm-only sessions are
# covered. See zellij-agent-state for the rules.
if status is-interactive
    and test -x ~/.config/zellij/scripts/zellij-agent-state
    ~/.config/zellij/scripts/zellij-agent-state prune </dev/null >/dev/null 2>&1 &
    disown
end
