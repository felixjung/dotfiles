local wezterm = require("wezterm")

local smart_splits =
	wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local smart_splits_config = {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "CTRL|META",
	},
}

local mod = {}

function mod.with_options(config)
	smart_splits.apply_to_config(config, smart_splits_config)
end

return mod
