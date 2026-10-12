# agent_ssh_agent: make sure the agents' ssh-agent runs and holds their key.
#
# The agent listens on its own socket, separate from 1Password's, and keeps the
# "GitHub Agent SSH" key until logout. The key is read through the service
# account (see agent-secret), so this works while 1Password is locked. sbx
# forwards it into sandboxes (ssh.agentSocketPath), where pisbx's agents sign
# and push with it.
#
# The key's public half is written next to the socket.
function agent_ssh_agent -d "start the agents' ssh-agent and load their key"
    set -l state $HOME/.local/state/agent-identity
    set -l sock $state/ssh-agent.sock

    mkdir -p $state; and chmod 700 $state; or return

    # ssh-add -l exits 2 when it can't reach an agent and 1 when it has no keys.
    SSH_AUTH_SOCK=$sock ssh-add -l >/dev/null 2>&1
    set -l agent_status $status
    if test $agent_status -eq 2
        rm -f $sock
        ssh-agent -a $sock >/dev/null; or return
    end

    if test $agent_status -ne 0
        agent-secret "op://Agents/GitHub Agent SSH/private key?ssh-format=openssh" \
            | SSH_AUTH_SOCK=$sock ssh-add -q -
        if test $pipestatus[1] -ne 0 -o $pipestatus[2] -ne 0
            echo "agent_ssh_agent: couldn't load the agent SSH key" >&2
            return 1
        end
    end
    SSH_AUTH_SOCK=$sock ssh-add -L >$state/signing.pub
end
