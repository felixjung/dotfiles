local wezterm = require("wezterm")

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local function scheme_for_appearance(appearance)
	if appearance:find("Light") then
		return "Catppuccin Latte"
	else
		return "Catppuccin Macchiato"
	end
end

return {
	-- Font
	font_size = 12.0,
	freetype_load_target = "Light",
	line_height = 1.2,

	font = font_with_fallback("Operator Mono SSm Lig", { weight = "Light" }),

	-- Colors
	color_scheme_dirs = { "/Users/Felix/.config/wezterm/colors" },
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

	-- Behavior
	window_close_confirmation = "NeverPrompt",

	-- Appearance
	dpi = 80.0,
	enable_tab_bar = false,
	default_cursor_style = "SteadyUnderline",
	window_decorations = "RESIZE",
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 10,
	},
}
