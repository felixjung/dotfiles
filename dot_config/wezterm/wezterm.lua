local wezterm = require("wezterm")

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local function scheme_for_appearance(appearance)
	if appearance:find("Light") then
		return "tokyonight_day"
	else
		return "tokyonight_storm"
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

	-- Tab bar
	enable_tab_bar = false,
	use_fancy_tab_bar = false,
	show_close_tab_button_in_tabs = false,
	show_tabs_in_tab_bar = true,
	show_tab_index_in_tab_bar = true,
	tab_bar_at_bottom = false,
	tab_and_split_indices_are_zero_based = true,

	-- Appearance
	default_cursor_style = "SteadyUnderline",
	window_decorations = "RESIZE",
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 10,
	},
}
