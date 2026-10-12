# Run pi through `op run` so 1Password-backed secrets (e.g. NPM_ACCESS_TOKEN,
# and at work the npm registry token) are resolved in the environment — pi shells
# out to `npm` on startup to install its extensions. --no-masking because pi is a
# TUI (matches the codex alias). Provider/model selection is per-machine in
# ~/.pi/agent/settings.json, so this alias is identical on every machine.
alias pi="op run --no-masking -- pi"

# pisbx: run pi for a worktree in its own Docker sandbox (sbx), with the
# agents' credentials injected by sbx (see the sbx setup script) instead of
# anything on this machine. Running it again for the worktree reuses the
# sandbox; arguments after the path go to pi (e.g. `pisbx . --continue`).
#
# The exception is MCP sign-ins: the sandbox gets pi's MCP servers but not their
# logins. Sign in once per sandbox with `/mcp login <server>`, open the URL
# here and paste the redirected URL back into pi.
#
# The sandbox mounts ~/worktrees, so worktrees pi creates show up here, the
# repo's primary checkout, so git can resolve the worktree's .git, and the
# worktree's pi sessions; paths match the host's. ~/worktrees comes first
# because sbx writes its agent instructions next to the first mount: into ~
# inside the VM, where pi finds them and the host never sees them.
function pisbx -d "run pi in a Docker sandbox for a worktree"
    set -l dir $PWD
    set -q argv[1]; and set dir $argv[1]
    set -l worktree (git -C $dir rev-parse --show-toplevel); or return
    set -l primary (path dirname (git -C $worktree rev-parse --path-format=absolute --git-common-dir))
    # sbx names allow letters, digits, hyphens and periods.
    set -l sandbox (path basename $worktree | string replace -ra '[^A-Za-z0-9.-]' -)

    agent_ssh_agent; or return

    # sbx's base image sets GH_TOKEN to a dummy for its built-in github
    # service, which we don't use (it breaks pi's Copilot login). gh prefers
    # GH_TOKEN; empty, it falls back to our GITHUB_TOKEN secret.
    set -l env_args --env GH_TOKEN=

    # The worktree's pi sessions, shared with pi on the host so either can
    # resume the other's (just not the same session at once). Host pi groups
    # sessions by working directory under this name; pi in the VM runs at the
    # same path but uses the folder directly, through
    # PI_CODING_AGENT_SESSION_DIR.
    set -l sessions ~/.pi/agent/sessions/--(string replace -r '^/' '' -- $worktree | string replace -ra '[/:]' -)--

    if not contains -- $sandbox (sbx ls --quiet)
        mkdir -p ~/worktrees $sessions
        set -l mounts ~/worktrees
        for path in $primary $worktree
            string match -q "$HOME/worktrees/*" -- $path
            or contains -- $path $mounts
            or set -a mounts $path
        end
        sbx create --name $sandbox ~/.config/sbx/kits/pi-dev \
            --kit docker.io/sbx/git-ssh-sign-kit:latest \
            $mounts $sessions; or return
    end

    # Sandboxes created before sessions were shared lack the mount; there, pi
    # keeps its sessions in the VM.
    set -l workspaces (sbx ls --json | jq -r --arg name $sandbox '.sandboxes[] | select(.name == $name) | .workspaces[]')
    contains -- $sessions $workspaces
    and set -a env_args --env PI_CODING_AGENT_SESSION_DIR=$sessions

    # Your instructions. On the host, pi reads ~/AGENTS.md as a parent of the
    # worktree; in the VM that path holds sbx's instructions instead. So put
    # yours, followed by pi's own, where pi always looks.
    begin
        cat ~/AGENTS.md 2>/dev/null; and echo
        cat ~/.pi/agent/AGENTS.md 2>/dev/null
    end | sbx exec --interactive $sandbox sh -c 'cat > "$HOME/.pi/agent/AGENTS.md"'

    # Plannotator's review UI is served by pi inside the VM. Forward the
    # sandbox's port block under the same numbers, so the localhost URL pi shows
    # opens here. sbx keeps forwarded ports with the sandbox, which the exec
    # above started, so its listing is complete.
    set -l ports (__pisbx_port_block $sandbox); or return
    set -l forwarded (sbx ports $sandbox --json | jq -r '.[].host_port')
    for port in $ports
        contains -- $port $forwarded
        or sbx ports $sandbox --publish $port:$port >/dev/null
        or return
    end
    set -a env_args --env PLANNOTATOR_PORT=$ports[1]-$ports[-1]

    # The repo's .tool-versions; quick once installed.
    sbx exec --workdir $worktree $env_args $sandbox mise install --quiet
    or echo "pisbx: mise install failed; continuing" >&2

    # sbx hides the agent process, so herdr needs a hint to detect pi.
    set -lx HERDR_AGENT pi
    sbx exec --interactive --tty --workdir $worktree $env_args $sandbox pi $argv[2..]
end

# __pisbx_port_block SANDBOX prints the 4 host ports reserved for SANDBOX's
# Plannotator sessions (several can run at once, e.g. from subagents),
# reserving a free block first. Reservations live in a file because sbx lists no
# ports for stopped sandboxes, and a stopped sandbox whose port was taken in the
# meantime fails to start.
function __pisbx_port_block -a sandbox
    set -l file ~/.local/state/pisbx/ports
    mkdir -p (path dirname $file)
    touch $file
    # Drop the reservations of removed sandboxes.
    set -l sandboxes (sbx ls --quiet)
    set -l kept
    for line in (cat $file)
        set -l entry (string split ' ' -- $line)
        contains -- $entry[1] $sandboxes; and set -a kept $line
    end
    string join \n -- $kept >$file

    set -l first (string match -r "^$(string escape --style=regex -- $sandbox) (\d+)\$" -- $kept)[2]
    if test -z "$first"
        set -l taken (string replace -r '.* ' '' -- $kept)
        for candidate in (seq 19432 4 19828)
            contains -- $candidate $taken; and continue
            set -l busy
            for port in (seq $candidate (math $candidate + 3))
                nc -z 127.0.0.1 $port 2>/dev/null; and set busy 1
            end
            if test -z "$busy"
                set first $candidate
                break
            end
        end
        if test -z "$first"
            echo "pisbx: no free port block for Plannotator" >&2
            return 1
        end
        echo "$sandbox $first" >>$file
    end
    seq $first (math $first + 3)
end

# Give the agent the `plannotator` tool (annotate/review with an approval gate);
# the documents skill's review gate depends on it.
set -gx PLANNOTATOR_AGENT_TOOL 1
