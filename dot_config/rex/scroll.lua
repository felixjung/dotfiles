local M = {}
local profiles = {
  scroll = "auto",
  ["scroll-terminal"] = "terminal",
  ["scroll-pi"] = "pi",
  ["scroll-codex"] = "codex",
}

function M.route(screen, process, status)
  if screen ~= "alternate" then
    return "terminal"
  end
  local p = process and process.foreground or {}
  for _, record in ipairs(status and status.records or {}) do
    local owner = record.owner
    local app = record.effective_app or record.app
    -- Only the root record describes the foreground app. Completed records
    -- survive shell prompts, so require both owner identity fields to match.
    if
      not record.id
      and owner
      and p.pid
      and p.name
      and owner.pid == p.pid
      and owner.name == p.name
      and (app == "pi" or app == "codex")
    then
      return app
    end
  end
  for _, value in ipairs({ p.script or "", p.path or "", p.invoked_path or "" }) do
    if value:match("/pi%-coding%-agent/dist/cli%.js$") or value:match("/pi$") then
      return "pi"
    elseif value:match("/codex$") then
      return "codex"
    end
  end
  return "terminal"
end

local function scroll(profile, direction, half, ctx)
  assert(ctx.session_id and ctx.block_id and ctx.client_id, "Scroll: terminal/client required")
  if profile == "auto" then
    local args = { session_id = ctx.session_id, block_id = ctx.block_id, args = {} }
    local modes = rex.call("com.superlogical.terminal.modes", args)
    local process = rex.call("com.superlogical.terminal.process", args)
    local status = rex.call("com.superlogical.terminal.program_status", args)
    profile = M.route(modes and modes.screen, process, status)
  end
  if profile == "terminal" then
    rex.client.queue("client.scroll.page_" .. direction)
  else
    local key = direction == "up" and "pageup" or "pagedown"
    if profile == "pi" and half then
      key = "ctrl+" .. key
    end
    rex.client.queue("pane.send_key", { key = key })
  end
end

function M.register()
  for key, target in pairs({
    a = "scroll",
    t = "scroll-terminal",
    p = "scroll-pi",
    c = "scroll-codex",
  }) do
    rex.action({
      name = "scroll_select_" .. key,
      title = "Scroll profile: " .. profiles[target],
      run = function()
        rex.client.queue("client.mode.exit")
        rex.client.queue("client.mode.enter", { name = target })
      end,
    })
  end
  for mode, profile in pairs(profiles) do
    rex.mode(mode, { exclusive = true })
    for _, key in ipairs({ "a", "t", "p", "c" }) do
      rex.bind(mode .. "/" .. key, "scroll_select_" .. key)
    end
    for key, spec in pairs({
      ["ctrl+u"] = { "up", true },
      ["ctrl+d"] = { "down", true },
      ["ctrl+b"] = { "up", false },
      ["ctrl+f"] = { "down", false },
    }) do
      local name = mode:gsub("%-", "_") .. "_" .. key:gsub("%+", "_")
      rex.action({
        name = name,
        title = "Scroll " .. spec[1] .. " (" .. profile .. ")",
        run = function(ctx)
          scroll(profile, spec[1], spec[2], ctx)
        end,
      })
      rex.bind(mode .. "/" .. key, name)
    end
    rex.bind(mode .. "/e", "scrollcopy")
    rex.bind(mode .. "/esc", "client.mode.exit")
  end
end
return M
