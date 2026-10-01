local wezterm = require("wezterm")

local util = require("util")

-- sessions.wezterm saves named workspaces and restores them after a reboot.
-- Loaded from the local checkout while it is being developed.
local plugin_dir = wezterm.home_dir .. "/Developer/sessions.wezterm"

local mod = {}

function mod.with_options(config)
	package.path = plugin_dir .. "/plugin/?.lua;" .. package.path
	local ok, sessions = pcall(dofile, plugin_dir .. "/plugin/init.lua")
	if not ok then
		wezterm.log_warn("sessions.wezterm not loaded: " .. tostring(sessions))
		return
	end

	for _, file in ipairs(wezterm.glob("plugin/**/*.lua", plugin_dir)) do
		wezterm.add_to_config_reload_watch_list(plugin_dir .. "/" .. file)
	end

	local actions = sessions.setup(config, {
		restore_on_startup = false,
	})

	config.keys = util.concat(config.keys, {
		{ key = "s", mods = "LEADER", action = actions.pick() },
		{ key = "N", mods = "LEADER|SHIFT", action = actions.new() },
		{ key = "$", mods = "LEADER|SHIFT", action = actions.rename() },
		{ key = "X", mods = "LEADER|SHIFT", action = actions.delete() },
		{ key = "L", mods = "LEADER|SHIFT", action = actions.previous() },
		{ key = "S", mods = "LEADER|SHIFT", action = actions.save() },
	})
end

return mod
