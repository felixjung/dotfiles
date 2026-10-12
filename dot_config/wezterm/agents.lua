-- Coding-agent status for the tab bar.
--
-- Agents (Claude Code, pi) report through
-- ~/.config/zellij/scripts/zellij-agent-state, which writes one file per
-- session under $XDG_STATE_HOME/zellij-agents, and keep their concatenation in
-- zellij-agents.tsv, which is what this module reads (wezterm.glob cannot be
-- called from format-tab-title: it yields, and that callback is synchronous). Zellij tabs read those files
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

local GLYPH = { waiting = "○", error = "✗", running = "◐", done = "✓" }
-- Higher wins when one tab holds several agents.
local RANK = { done = 1, running = 2, error = 3, waiting = 4 }

local cache = { at = 0, by_pane = {} }

local function index_path()
	local root = os.getenv("XDG_STATE_HOME") or (wezterm.home_dir .. "/.local/state")
	return root .. "/zellij-agents.tsv"
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
	local f = io.open(index_path(), "r")
	if f then
		for line in f:lines() do
			-- status cwd subagents epoch session agent wezterm_pane
			local v = split_tabs(line)
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
		f:close()
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
	local counts = { waiting = 0, error = 0, running = 0, done = 0 }
	for _, entry in pairs(load()) do
		counts[entry.status] = counts[entry.status] + 1
	end
	local parts = {}
	for _, s in ipairs({ "waiting", "error", "running", "done" }) do
		if counts[s] > 0 then
			parts[#parts + 1] = GLYPH[s] .. counts[s]
		end
	end
	return table.concat(parts, " ")
end

return mod
