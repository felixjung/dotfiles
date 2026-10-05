# Homebrew's rustup is keg-only: its rustc/cargo proxies live under opt/.
fish_add_path "$(brew --prefix)/opt/rustup/bin"

if test -d ~/.cargo/bin
    fish_add_path ~/.cargo/bin
end
