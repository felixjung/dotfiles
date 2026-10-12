local wezterm = require("wezterm")
local agents = require("agents")

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

	config.adjust_window_size_when_changing_font_size = false
end

-- Side effects
wezterm.on("update-status", function(window, _)
	local summary = agents.summary()
	if summary ~= "" then
		summary = summary .. "  "
	end
	window:set_right_status(" " .. summary .. window:active_workspace() .. " ")
end)

-- Same layout as the default retro tab, plus the agent badge. The badge
-- follows the title so it survives tab_max_width truncation of long titles.
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local title = tab.tab_title
	if title == "" then
		title = tab.active_pane.title
	end
	local badge = agents.badge(agents.tab_status(tab.tab_id))
	-- A custom format replaces the built-in index prefix, so add it back.
	local prefix = tab.tab_index .. ": "
	local room = max_width - wezterm.column_width(prefix .. badge) - 2
	if room < 1 then
		room = 1
	end
	return " " .. prefix .. wezterm.truncate_right(title, room) .. badge .. " "
end)

return mod
