local wezterm = require("wezterm")

local util = require("util")

-- resurrect is a plugin that stores and restores workspace state.
local resurrect =
	wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- resurrect.set_encryption({
--     enable = false,
--     method = "age",
--     private_key = wezterm.config_dir .. "../age/key.txt",
--     public_key = "age1e0yqrnkup3faajva9mzlzmmhcg39r532xek5gueskw2crjge9ypqrlyafn",
-- })
-- resurrect.change_state_save_dir("~/.local/state/wezterm/")
resurrect.periodic_save()

wezterm.on(
	"smart_workspace_switcher.workspace_switcher.created",
	function(window, _, label)
		local workspace_state = resurrect.workspace_state

		workspace_state.restore_workspace(
			resurrect.load_state(label, "workspace"),
			{
				window = window,
				relative = true,
				restore_text = false,
				on_pane_restore = resurrect.tab_state.default_on_pane_restore,
			}
		)
	end
)

wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function()
	local workspace_state = resurrect.workspace_state
	resurrect.save_state(workspace_state.get_workspace_state())
end)

local key_bindings = {
	{
		key = "S",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.save_state(resurrect.workspace_state.get_workspace_state())
		end),
	},
	{
		key = "R",
		mods = "LEADER",
		action = wezterm.action_callback(function(win, pane)
			resurrect.fuzzy_load(win, pane, function(id, label)
				local type = string.match(id, "^([^/]+)") -- match before '/'
				id = string.match(id, "([^/]+)$") -- match after '/'
				id = string.match(id, "(.+)%..+$") -- remove file extention
				local opts = {
					relative = true,
					restore_text = false,
					on_pane_restore = resurrect.tab_state.default_on_pane_restore,
				}
				if type == "workspace" then
					local state = resurrect.load_state(id, "workspace")
					resurrect.workspace_state.restore_workspace(state, opts)
				elseif type == "window" then
					local state = resurrect.load_state(id, "window")
					resurrect.window_state.restore_window(pane:window(), state, opts)
				elseif type == "tab" then
					local state = resurrect.load_state(id, "tab")
					resurrect.tab_state.restore_tab(pane:tab(), state, opts)
				end
			end)
		end),
	},
}

local mod = {}

function mod.with_options(config)
	config.keys = util.concat(config.keys, key_bindings)
end

return mod
