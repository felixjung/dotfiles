# Lazygit configuration

## Intent and agreed approach

Manage lazygit in chezmoi, matching the existing Catppuccin Latte/light and
Macchiato/dark pairing. The user chose delta as the default renderer and
difftastic as an optional renderer, with plain Git as a fallback.

## Approaches

- Theme only: minimal setup, but would omit the existing delta styling.
- Theme plus selectable renderers: chosen; reuses delta and adds structural diffs.
- Broader workflow customization: defer until there is a concrete need.

## Design and constraints

- Require lazygit >= 0.66 for native light/dark themes and renderer templates.
- Keep one static `~/.config/lazygit/config.yml`; its Go templates belong to lazygit.
- On macOS, link the default Application Support config location to that file so
  direct Rex launches also find it without XDG environment variables.
- Renderer order: delta, difftastic, plain. Use `|` and `\` to cycle.
- Delta selects the existing Catppuccin feature using lazygit's detected scheme.
- Difftastic uses the detected background, diff panel width, and context size.
  It has no custom palette setting; retain its standard ANSI colors.
- Blue is the proposed interface accent. Preserve existing confirmation settings,
  keybindings, Git behavior, Rex configuration, and manual edits.
- Both delta and difftastic are already installed and declared as macOS packages.
- Apply only the two lazygit targets. Do not commit or apply unrelated work.

## Verification

Inspect chezmoi's rendered targets, validate renderer order and YAML, exercise
both renderer commands with light/dark settings, and check native lazygit startup
and renderer switching in a temporary repository. Verify the applied config and
macOS link match the source. Report any runtime check that cannot be completed.
