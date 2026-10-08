# agent_identity: run a command with the agents' own git/GitHub identity.
#
# Agents sign, push and call `gh` with credentials from the 1Password "Agents"
# vault, read through a service account, so they keep working while the
# 1Password app is locked. The service account token lives in the login
# Keychain (service "op-agent-token") and is only ever passed to `op read`;
# exporting it would make `op run` sign in as the service account too.
#
# The signing key is loaded into a dedicated ssh-agent, separate from the
# 1Password one, which keeps it until logout. Git, ssh and gh only see the
# agent identity through variables local to this function, so the calling
# shell keeps using your own.
#
# example usage:
#   agent_identity op run -- pi
function agent_identity -d "run a command with the agent git/GitHub identity"
    # Machines without the token keep running agents as you.
    set -l sa_token (security find-generic-password -s op-agent-token -w 2>/dev/null)
    or begin
        echo "agent_identity: no 'op-agent-token' Keychain item, running as you" >&2
        $argv
        return
    end

    set -l state $HOME/.local/state/agent-identity
    set -l sock $state/ssh-agent.sock
    set -l pubkey $state/signing.pub

    mkdir -p $state; and chmod 700 $state; or return

    # ssh-add -l exits 2 when it can't reach an agent and 1 when it has no keys.
    SSH_AUTH_SOCK=$sock ssh-add -l >/dev/null 2>&1
    set -l agent_status $status
    if test $agent_status -eq 2
        rm -f $sock
        ssh-agent -a $sock >/dev/null; or return
    end

    if test $agent_status -ne 0
        OP_SERVICE_ACCOUNT_TOKEN=$sa_token op read "op://Agents/GitHub Agent SSH/private key?ssh-format=openssh" \
            | SSH_AUTH_SOCK=$sock ssh-add -q -
        if test $pipestatus[1] -ne 0 -o $pipestatus[2] -ne 0
            echo "agent_identity: couldn't load the agent SSH key" >&2
            return 1
        end
    end
    SSH_AUTH_SOCK=$sock ssh-add -L >$pubkey; or return

    set -l gh_token (OP_SERVICE_ACCOUNT_TOKEN=$sa_token op read "op://Agents/GitHub Agent PAT/token")
    or begin
        echo "agent_identity: couldn't read the agent GitHub PAT" >&2
        return 1
    end

    # Marker for shell config that would otherwise route through 1Password
    # (op plugin aliases, op:// GH_TOKEN references).
    set -lx AGENT_IDENTITY 1
    set -lx GH_TOKEN $gh_token
    # ssh-keygen signs through the agent; ssh itself ignores SSH_AUTH_SOCK
    # because ~/.ssh/config sets IdentityAgent, hence core.sshCommand below.
    set -lx SSH_AUTH_SOCK $sock

    set -l git_config \
        gpg.format ssh \
        gpg.ssh.program ssh-keygen \
        user.signingkey $pubkey \
        commit.gpgsign true \
        core.sshCommand "ssh -o IdentityAgent=$sock -o IdentityFile=$pubkey -o IdentitiesOnly=yes"
    set -lx GIT_CONFIG_COUNT (math (count $git_config) / 2)
    for i in (seq 0 (math $GIT_CONFIG_COUNT - 1))
        set -fx GIT_CONFIG_KEY_$i $git_config[(math 2 \* $i + 1)]
        set -fx GIT_CONFIG_VALUE_$i $git_config[(math 2 \* $i + 2)]
    end

    $argv
end
