local wezterm = require("wezterm")
local util = require("util")

local act = wezterm.action

local mod = {}

function mod.with_options(config)
	local keyBindings = {
		-- tmux behavior
		{
			key = "[",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},

		{
			key = "f",
			mods = "LEADER",
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

		{
			-- Create and activate a new workspace
			key = "w",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
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
	}

	-- Programmatically define key bindings for activating
	-- tabs by index.

	for i = 0, 8 do
		table.insert(keyBindings, {
			key = tostring(i),
			mods = "LEADER",
			action = act.ActivateTab(i),
		})
	end

	config.keys = util.concat(config.keys, keyBindings)
	config.use_dead_keys = true
	config.send_composed_key_when_left_alt_is_pressed = true
	config.send_composed_key_when_right_alt_is_pressed = true
end

return mod
