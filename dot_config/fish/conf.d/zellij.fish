# Auto-attach a Zellij session on interactive shell start.
# Inert by default — opt in with: set -Ux ZELLIJ_AUTO_ATTACH 1
# Guards against nesting inside an existing Zellij or tmux session.
if status is-interactive
    and set -q ZELLIJ_AUTO_ATTACH
    and not set -q ZELLIJ
    and not set -q TMUX
    zellij attach --create main
end

# Context-specific tab names.
#
# The tab follows this shell's directory until something deliberately renames
# it — wald's post-switch hook, or Ctrl+t r — after which that name is pinned
# and only the agent status badge keeps updating. `ztab-unpin` releases it.
# The pin rule itself lives in zellij-tab-sync; this just triggers a resync.
if status is-interactive
    and set -q ZELLIJ
    # Resolve our tab once per shell and cache it. It only changes if the pane
    # is moved to another tab, which is rare enough to not pay a `list-panes`
    # round trip on every `cd` for.
    if not set -q ZELLIJ_TAB_ID
        and set -q ZELLIJ_PANE_ID
        and type -q jq
        set -l pane (string replace -r '^(terminal|plugin)_' '' -- $ZELLIJ_PANE_ID)
        if string match -qr '^\d+$' -- $pane
            set -l id (zellij action list-panes -a -j 2>/dev/null | jq -r \
                --argjson p $pane \
                'first(.[] | select(.is_plugin == false and .id == $p) | .tab_id) // empty' 2>/dev/null)
            and test -n "$id"
            and set -gx ZELLIJ_TAB_ID $id
        end
    end

    function __zellij_sync_tab_name --on-variable PWD -d 'Keep the Zellij tab name in step with $PWD'
        command -q zellij
        and ~/.config/zellij/scripts/zellij-tab-sync 2>/dev/null
    end

    # Once per shell, also garbage-collect state left by sessions that are
    # gone. --gc costs an extra `zellij list-sessions`, so it deliberately
    # does NOT run from the PWD hook above.
    command -q zellij
    and ~/.config/zellij/scripts/zellij-tab-sync --gc 2>/dev/null
end
