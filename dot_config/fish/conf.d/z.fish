# zoxide: smarter cd. https://github.com/ajeetdsouza/zoxide
#
# Generate the shell integration at runtime rather than vendoring a static copy
# of `zoxide init fish` — a frozen copy drifts from the installed zoxide/fish
# versions (e.g. fish 4.x moved `cd` from a share/ file into the binary).
if type -q zoxide
    zoxide init fish | source
end
