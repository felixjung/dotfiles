local wezterm = require("wezterm")

local act = wezterm.action

-- Plugins
local smart_splits =
	wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local resurrect =
	wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
local workspace_switcher = wezterm.plugin.require(
	"https://github.com/MLFlexer/smart_workspace_switcher.wezterm"
)

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

-- Multiplexing
config.unix_domains = {
	{
		name = "unix",
		no_serve_automatically = false,
		skip_permissions_check = false,
	},
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

	-- Workspaces

	-- Prompt for a name to use for a new workspace and switch to it.
	{
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "s",
		mods = "LEADER",
		action = workspace_switcher.switch_workspace(),
	},
	{
		key = "S",
		mods = "LEADER",
		action = workspace_switcher.switch_to_prev_workspace(),
	},

	-- Resurrect
	-- {
	-- 	key = "s",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action_callback(function(_, _)
	-- 		resurrect.save_state(resurrect.workspace_state.get_workspace_state())
	-- 	end),
	-- },
	-- {
	-- 	key = "r",
	-- 	mods = "LEADER",
	-- 	action = wezterm.action_callback(function(win, pane)
	-- 		resurrect.fuzzy_load(win, pane, function(id, label)
	-- 			local type = string.match(id, "^([^/]+)") -- match before '/'
	-- 			id = string.match(id, "([^/]+)$") -- match after '/'
	-- 			id = string.match(id, "(.+)%..+$") -- remove file extention
	-- 			local opts = {
	-- 				relative = true,
	-- 				restore_text = true,
	-- 				on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	-- 			}
	-- 			if type == "workspace" then
	-- 				local state = resurrect.load_state(id, "workspace")
	-- 				resurrect.workspace_state.restore_workspace(state, opts)
	-- 			elseif type == "window" then
	-- 				local state = resurrect.load_state(id, "window")
	-- 				resurrect.window_state.restore_window(pane:window(), state, opts)
	-- 			elseif type == "tab" then
	-- 				local state = resurrect.load_state(id, "tab")
	-- 				resurrect.tab_state.restore_tab(pane:tab(), state, opts)
	-- 			end
	-- 		end)
	-- 	end),
	-- },
}

for i = 0, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateWindow(i),
	})
end

-- Workspaces
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

-- Apply plugin configs.

smart_splits.apply_to_config(config, {
	direction_keys = { "h", "j", "k", "l" },
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
})

resurrect.set_encryption({
	enable = false,
	method = "age",
	private_key = wezterm.config_dir .. "../age/key.txt",
	public_key = "age1e0yqrnkup3faajva9mzlzmmhcg39r532xek5gueskw2crjge9ypqrlyafn",
})
resurrect.change_state_save_dir("~/.local/state/wezterm")
resurrect.periodic_save()

wezterm.on(
	"smart_workspace_switcher.workspace_switcher.chosen",
	function(window, workspace)
		local gui_win = window:gui_window()
		local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
		gui_win:set_right_status(wezterm.format({
			{ Foreground = { Color = "green" } },
			{ Text = base_path .. "  " },
		}))
	end
)

wezterm.on(
	"smart_workspace_switcher.workspace_switcher.created",
	function(window, workspace)
		local gui_win = window:gui_window()
		local base_path = string.gsub(workspace, "(.*[/\\])(.*)", "%2")
		gui_win:set_right_status(wezterm.format({
			{ Foreground = { Color = "green" } },
			{ Text = base_path .. "  " },
		}))
	end
)
workspace_switcher.workspace_formatter = function(label)
	return wezterm.format({
		{ Attribute = { Italic = true } },
		{ Foreground = { Color = "green" } },
		{ Background = { Color = "black" } },
		{ Text = "󱂬: " .. label },
	})
end
workspace_switcher.apply_to_config(config)

return config
