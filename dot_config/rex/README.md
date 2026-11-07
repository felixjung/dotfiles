# Source-only Rex Lua development

Edit runtime Lua in this chezmoi source, then apply only the intended runtime
files. Tool configs, API definitions, this README and the Makefile are excluded
from target sync. Previously deployed, ignored target tests are left untouched.

Run `make -C dot_config/rex check` from the repository, or `make check` here.
Native targets:

- `format` / `format-check`: StyLua, Lua 5.1 syntax, two-space indentation,
  100-column width; no import sorting.
- `lint`: Selene, separately for Rex runtime and the Neovim viewer.
- `runtime-check`: load the source config with the exact installed Rex executable;
  this checks loading, not subsequent action execution, and does not reload Rex.
- `check`: formatting verification, lint and runtime loading.

LuaLS remains active in the editor, with nearest buffer-local `.luarc.json`
profiles. Rex uses Lua 5.1 and source-only `types/rex.lua` for its API subset;
`viewer/` uses LuaJIT and installed Neovim plus LuaLS luv definitions. Parent
analysis excludes the viewer, so host globals do not leak. Existing lazydev
defers to explicit profiles. LuaLS is not a Makefile CLI gate.

Make and existing editor integrations prefer Homebrew binaries when available;
Mason installations are retained. The viewer's native LuaLS configuration uses
`/opt/homebrew/opt/neovim/share/nvim/runtime/lua` on this Mac.

## Persistent scroll mode

`ctrl+a>[` enters the exclusive `scroll` mode until `q` or `esc` leaves it.

| Mode key | Action |
| --- | --- |
| `ctrl+u` / `ctrl+d` | Forward Ctrl+PageUp / Ctrl+PageDown (Pi half-page scrolling) |
| `ctrl+b` / `ctrl+f` | Forward PageUp / PageDown (Pi full-page scrolling) |
| `pageup` / `pagedown` | Rex-native terminal scrollback page up / down |
| `e` | `scrollcopy`: open the existing isolated snapshot viewer for copying |
| `q` / `esc` | Exit the mode |

The other 32 global bindings, including `ctrl+a>ctrl+a` passthrough, are unchanged.
Setting `enabled = false` in `init.lua` registers no bindings or modes; the
independent Open Lazygit palette action remains available.
The standalone `scrollback_viewer` action remains available without mode exits.

`scrollcopy` queues `client.mode.exit_all` before calling the existing viewer
routine, so a missing client fails before creating a viewer. Rex executes queued
client actions **after the action's run callback returns successfully** and
**discards them on failure**. The exit is not executed before capture/launch;
after a successful callback the client leaves all modes so the final viewer can
receive normal keys. No client execution is performed by the static checks.

Copying captures only the currently rendered Pi page, not hidden Pi history.
Ordinary terminal snapshots open at the bottom; no scroll-position tracking or
process sniffing is performed. In the viewer, select text and use `y`/`yy` to
copy; `q` closes it. Scrolling itself does not write the clipboard.

## Open Lazygit

The `lazygit` palette action (title **Open Lazygit**) is always registered;
`ctrl+a>g` is available only with the key layer enabled. Each invocation creates
a fresh centered 90% floating terminal in the active tab. It uses that tab's
focused local terminal, ignoring stale invocation block IDs. The actual foreground
process cwd is required and validated with read-only Git `rev-parse`; there is no
OSC7, child-process, home-directory or source-directory fallback.

The terminal starts in the Git repository root. A static argv-based shell guard
must successfully `cd` there before executing installed `/opt/homebrew/bin/lazygit`,
so Rex's terminal cwd fallback cannot launch Lazygit in home. Lazygit's `q` exits
normally and closes its terminal/layer; no popup reuse manager is involved.

The pane uses `shell = "none"` and Rex's `path_prepend` option to add
`/opt/homebrew/bin` and `~/.local/bin` ahead of the inherited `PATH`. This lets
Lazygit find delta, difftastic, and Homebrew-installed editors without loading
shell startup files.

Tab, focus and foreground identity are rechecked before/after creation. Creation
does not focus; only the returned block is focused. Failures close only the new
owned layer. These RPC checks are not atomic: a tab can change between the last
check and focus, and repository contents/path identity can change after validation.
The shell guard prevents a disappeared directory from executing Lazygit, but does
not lock directory identity or restore user focus across races.

Runtime files are `init.lua`, `keys.lua`, `scrollback.lua`, `lazygit.lua`, and
`viewer/init.lua`.
The GUI snapshot remains native-authoritative; these targets do not write
preferences, change clipboard contents, reload Rex or restart applications.
