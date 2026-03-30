local wezterm = require("wezterm")

local function scheme_for_appearance(appearance)
	if appearance:find("Light") then
		-- return "tokyonight_day"
		return "catppuccin-latte"
	else
		return "catppuccin-macchiato"
	end
end

local mod = {}

function mod.with_options(config)
	config.color_scheme_dirs = { wezterm.config_dir .. "/colors" }
	config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
end

return mod
