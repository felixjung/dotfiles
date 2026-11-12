# Source-only Rex Lua development

## GUI preferences and agent setup

`gui-settings.plist` is a portable snapshot of selected macOS settings. Rex
does **not** read that file directly. On macOS, `chezmoi apply` copies it and
the `darwin-rex-settings` script imports its keys into `com.superlogical.rex`
through User Defaults. The script runs on first apply and whenever the snapshot
changes. Unrelated preferences and session state survive; later edits in Rex
remain until a changed snapshot is applied.

Quit and reopen the Rex app after importing settings. Applying does not restart
Rex or its server. The configured fonts must already be installed on that Mac:
Operator Mono SSm Lig (Book) and FiraCode Nerd Font. This repository does not
distribute those font files.

To save future GUI changes, update the snapshot from the live preferences,
keeping machine-local and runtime state out of it. Merely re-adding the copy in
`~/.config/rex` will not capture edits made in Rex.

The separate `darwin-rex-agents` script runs `rex skill setup --session-naming`
after each macOS apply, installing the skills and supported session hooks for
detected agents. It skips setup until the Rex CLI is installed. Start a new
agent session after setup; Codex requires approval of its hook through `/hooks`.
Claude Code's Rex hook is also retained in its managed settings template.

The Rex community MCP at `https://www.superlogical.com/rex/community-mcp`
provides documentation and community discussions; it does not apply settings.
Its Discord OAuth authorization remains local to each machine.

Test the actual chezmoi apply lifecycle and preferences import on macOS with
`python3 dot_config/rex/tests/test_preferences.py`. It uses a temporary defaults
domain and checks that fonts, themes, and other saved types import, unrelated
state survives, manual app edits survive an unchanged apply, and snapshot
changes trigger a new import. It leaves the live Rex preferences untouched.

## Lua development

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
- `test`: shared scratch action tests under LuaJIT, using mocked Rex calls.
- `check`: formatting verification, lint, scratch tests and runtime loading.

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

Other global bindings, including `ctrl+a>ctrl+a` passthrough, are unchanged.
Setting `enabled = false` in `init.lua` registers no bindings or modes; the
independent Open Lazygit and Toggle Shared Scratch Terminal palette actions remain available.
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

Runtime files are `init.lua`, `keys.lua`, `scrollback.lua`, `lazygit.lua`, `scratch.lua`, and
`viewer/init.lua`.
These Make targets do not write GUI preferences, change clipboard contents,
reload Rex or restart applications. The separate chezmoi apply script imports
the GUI snapshot as described above.

## Shared floating scratch terminal

`ctrl+a>f` invokes **Toggle Shared Scratch Terminal** (`toggle_scratch`). The
palette action is always registered; its shortcut follows the custom key layer's
`enabled` setting. The first invocation creates a centered 70% floating default
shell in the focused local terminal's foreground working directory. Missing
terminal context or cwd fails without creating a shell in a fallback directory.

Each session has its own shell. When the scratch pane is focused, the shortcut
minimizes it without stopping its program. Otherwise it restores, raises and
focuses it. Invoking in another tab brings the same running terminal into that
tab, retaining its cwd, program, scrollback and latest floating bounds. Tab
switches alone do not move it. The existing Lazygit action is separate.

Rex floats are natively tab-scoped. A transfer uses `session.move_block` followed
by `session.float_block`: this can briefly redraw a split, resize its programs,
and end pane zoom. Both tabs must have tiled panes. If floating fails after the
move, the shell remains running in the destination split; use **Float Pane** to
recover it. Failures never close the shell or unrelated panes. The calls are not
atomic; concurrent layout changes can still race with the preflight checks.

The reserved label `__rex_shared_scratch` identifies the shell across config
reloads. Do not reuse it on other panes. Duplicate labels, detached terminals,
or a manually docked/split scratch pane cause the action to stop without altering
them. Restore a single-pane float to resume, or rename it to opt out and allow
the next invocation to create another scratch. Closing the pane or its containing
tab ends that shell. The next invocation starts fresh; server restart does not
guarantee preservation of running programs.

Run `make -C dot_config/rex test` for action tests. Source-only tests and type
definitions are already excluded from chezmoi deployment. Apply only the changed
runtime Lua files and reload Rex; no GUI preference import or restart is needed.
