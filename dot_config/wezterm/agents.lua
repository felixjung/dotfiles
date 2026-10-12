-- Coding-agent status for the tab bar.
--
-- Agents (Claude Code, pi) report through
-- ~/.config/zellij/scripts/zellij-agent-state, which writes one file per
-- session under $XDG_STATE_HOME/zellij-agents. Zellij tabs read those files
-- via zellij-tab-sync; this module is the WezTerm half. Format and rationale:
-- see the header of zellij-agent-state.
--
-- Tabs are matched by WezTerm pane id ($WEZTERM_PANE, recorded by the hook),
-- not by directory, so two tabs in one repo stay distinct. Agents running
-- inside Zellij record no pane id and are not shown here: Zellij's own bar
-- covers them.
local wezterm = require("wezterm")

local mod = {}

local STALE_SECONDS = 6 * 60 * 60
local CACHE_SECONDS = 1

local GLYPH = { waiting = "●", running = "◐", done = "✓" }
-- Higher wins when one tab holds several agents.
local RANK = { done = 1, running = 2, waiting = 3 }

local cache = { at = 0, by_pane = {} }

local function state_dir()
	local root = os.getenv("XDG_STATE_HOME") or (wezterm.home_dir .. "/.local/state")
	return root .. "/zellij-agents"
end

local function split_tabs(line)
	local out = {}
	for field in (line .. "\t"):gmatch("([^\t]*)\t") do
		out[#out + 1] = field
	end
	return out
end

-- Returns { [pane_id] = { status = ..., subagents = n } }, re-read at most
-- once a second however often the tab bar repaints.
local function load()
	local now = os.time()
	if now - cache.at < CACHE_SECONDS then
		return cache.by_pane
	end

	local by_pane = {}
	for _, path in ipairs(wezterm.glob(state_dir() .. "/*")) do
		local f = io.open(path, "r")
		if f then
			local line = f:read("*l")
			f:close()
			-- status cwd subagents epoch session agent wezterm_pane
			local v = line and split_tabs(line) or {}
			local pane = tonumber(v[7])
			local epoch = tonumber(v[4])
			if pane and epoch and RANK[v[1]] and now - epoch <= STALE_SECONDS then
				local entry = by_pane[pane] or { status = v[1], subagents = 0 }
				if RANK[v[1]] > RANK[entry.status] then
					entry.status = v[1]
				end
				entry.subagents = entry.subagents + (tonumber(v[3]) or 0)
				by_pane[pane] = entry
			end
		end
	end

	cache = { at = now, by_pane = by_pane }
	return by_pane
end

-- Status for a tab: the most urgent state among its panes, or nil.
function mod.tab_status(tab_id)
	local ok, tab = pcall(wezterm.mux.get_tab, tab_id)
	if not ok or not tab then
		return nil
	end
	local by_pane = load()
	local result
	for _, pane in ipairs(tab:panes()) do
		local entry = by_pane[pane:pane_id()]
		if entry and (not result or RANK[entry.status] > RANK[result.status]) then
			result = entry
		end
	end
	return result
end

function mod.badge(status)
	if not status then
		return ""
	end
	local badge = " " .. GLYPH[status.status]
	if status.subagents > 0 then
		badge = badge .. status.subagents
	end
	return badge
end

-- One-line summary across every pane in the window's workspace, for the right
-- status. Also what makes the tab bar repaint when a state file changes:
-- WezTerm only redraws when the status text does.
function mod.summary()
	local counts = { waiting = 0, running = 0, done = 0 }
	for _, entry in pairs(load()) do
		counts[entry.status] = counts[entry.status] + 1
	end
	local parts = {}
	for _, s in ipairs({ "waiting", "running", "done" }) do
		if counts[s] > 0 then
			parts[#parts + 1] = GLYPH[s] .. counts[s]
		end
	end
	return table.concat(parts, " ")
end

return mod
