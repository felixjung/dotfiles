# Agent sessions (see agent_identity) carry their own credentials; the plugin
# aliases would route gh & co. back through the 1Password app.
if not set -q AGENT_IDENTITY
    source "$XDG_CONFIG_HOME/op/plugins.sh"
end
