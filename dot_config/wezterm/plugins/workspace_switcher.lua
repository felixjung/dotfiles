local wezterm = require("wezterm")

local util = require("util")

local workspace_switcher = wezterm.plugin.require(
	"https://github.com/MLFlexer/smart_workspace_switcher.wezterm"
)

local mod = {}

function mod.with_options(config)
	-- smark_workspace_switcher's apply_to_config function only sets two
	-- key-bindings, which we don't want.
	table.insert(config.keys, {
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	})
end

return mod
