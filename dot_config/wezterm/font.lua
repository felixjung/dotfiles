local wezterm = require("wezterm")

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local mod = {}

function mod.with_options(config)
	config.font_size = 12.0
	config.freetype_load_target = "Light"
	config.line_height = 1.2
	config.font =
		font_with_fallback("Operator Mono SSm Lig", { weight = "Light" })
end

return mod
