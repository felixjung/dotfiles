local wezterm = require("wezterm")

-- Config modules
local keys = require("keys")
local colors = require("colors")
local ui = require("ui")
local font = require("font")

-- Plugins
local smart_splits = require("plugins/smart_splits")
local resurrect = require("plugins/resurrect")
local workspace_switcher = require("plugins/workspace_switcher")

local config = wezterm.config_builder()

config.keys = {}

keys.with_options(config)
colors.with_options(config)
ui.with_options(config)
font.with_options(config)

smart_splits.with_options(config)
workspace_switcher.with_options(config)
resurrect.with_options(config)

-- Multiplexing
config.unix_domains = {
	{
		name = "unix",
		no_serve_automatically = false,
		skip_permissions_check = false,
	},
}
-- NOTE: don't use non-local domains because it causes issues with saving text.
-- config.default_gui_startup_args = { "connect", "unix" }
config.default_workspace = "~"

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

return config
