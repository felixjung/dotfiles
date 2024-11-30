local wezterm = require("wezterm")

local act = wezterm.action

-- Plugins
local smart_splits =
	wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local resurrect =
	wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "FiraCode Nerd Font" }
	return wezterm.font_with_fallback(names, params)
end

local function scheme_for_appearance(appearance)
	if appearance:find("Light") then
		return "Tokyo Night Day"
	else
		return "Tokyo Night Storm"
	end
end

local config = wezterm.config_builder()

-- Font
config.font_size = 12.0
config.freetype_load_target = "Light"
config.line_height = 1.2

config.font = font_with_fallback("Operator Mono SSm Lig", { weight = "Light" })

-- Colors
config.color_scheme_dirs = { wezterm.config_dir .. "/colors" }
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Behavior
config.window_close_confirmation = "NeverPrompt"

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.show_tabs_in_tab_bar = true
config.tab_max_width = 30
config.show_tab_index_in_tab_bar = true
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = true

-- Appearance
config.default_cursor_style = "SteadyUnderline"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 10,
}

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	-- tmux behavior
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},

	{
		key = "f",
		mods = "ALT",
		action = act.TogglePaneZoomState,
	},

	-- Pane and window management
	{
		-- Create new tab
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		-- Previous tab
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		-- Next tab
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		-- Tab navigator
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{
		-- Force close current tab
		key = "&",
		mods = "LEADER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		-- Swap panes
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		-- Go to previous pane
		key = ";",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Prev"),
	},
	{
		-- Go to next pane
		key = "o",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Next"),
	},
	{
		-- Vertical split
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		-- Horizontal split
		key = "-",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},

	-- Resurrect
	{
		key = "w",
		mods = "ALT",
		action = wezterm.action_callback(function(_, _)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "W",
		mods = "ALT",
		action = resurrect.window_state.save_window_action(),
	},
	{
		key = "T",
		mods = "ALT",
		action = resurrect.tab_state.save_tab_action(),
	},
	{
		key = "s",
		mods = "ALT",
		action = wezterm.action_callback(function(_, _)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
			resurrect.window_state.save_window_action()
		end),
	},
}

for i = 0, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateWindow(i),
	})
end

-- Apply plugin configs.

smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
})

return config
