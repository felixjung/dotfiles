local wezterm = require("wezterm")

local mod = {}

function mod.with_options(config)
	-- Tab bar
	config.enable_tab_bar = true
	config.use_fancy_tab_bar = false
	config.switch_to_last_active_tab_when_closing_tab = true
	config.show_tabs_in_tab_bar = true
	config.tab_max_width = 30
	config.show_tab_index_in_tab_bar = true
	config.tab_bar_at_bottom = true
	config.tab_and_split_indices_are_zero_based = true

	-- Updates
	config.status_update_interval = 1000

	-- Appearance
	config.default_cursor_style = "SteadyUnderline"
	config.window_decorations = "RESIZE"
	config.window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 10,
	}
end

-- Side effects
wezterm.on("update-status", function(window, _)
	window:set_right_status(" " .. window:active_workspace() .. " ")
end)

return mod
