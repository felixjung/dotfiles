local M = {}
local terminal = "com.superlogical.terminal"
local label = "__rex_shared_scratch"
local busy = {}

local function check(value, message)
  if not value then
    error("Shared Scratch: " .. message, 0)
  end
  return value
end

local function call(method, args)
  -- Do not expose server payloads, which can contain private filesystem data.
  return check(rex.call(method, args), method .. " failed; existing terminals were preserved")
end

local function active(view)
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      return window
    end
  end
  error("Shared Scratch: no active tab", 0)
end

local function locate(view, block_id)
  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        if block.block_id == block_id then
          return window, layer, block
        end
      end
    end
  end
end

local function anchor(window)
  local first
  for _, layer in ipairs(window.layers or {}) do
    if layer.kind == "tiled" then
      for _, block in ipairs(layer.blocks or {}) do
        first = first or block.block_id
        if block.block_id == window.focused_block_id then
          return block.block_id
        end
      end
    end
  end
  return first
end

local function unchanged(session_id, window)
  local current = active(call("session.view", { session_id = session_id }))
  check(
    current.window_id == window.window_id and current.focused_block_id == window.focused_block_id,
    "active tab or focused pane changed; invoke again"
  )
end

local function create(session_id, view, window, host_id)
  local _, _, source = locate(view, window.focused_block_id)
  check(
    source and source.creator_name == terminal and source.host_id == host_id,
    "focused pane must be a local terminal"
  )
  local process = call(terminal .. ".process", {
    session_id = session_id,
    block_id = source.block_id,
    args = {},
  }).foreground
  check(
    process and type(process.cwd) == "string" and process.cwd:sub(1, 1) == "/",
    "focused terminal's working directory is unavailable"
  )
  unchanged(session_id, window)
  local created = call("session.new_layer", {
    session_id = session_id,
    window_id = window.window_id,
    bounds = { 0.15, 0.15, 0.7, 0.7 },
    focus = false,
    layout = {
      block = {
        flavor = terminal .. ".shell",
        label = label,
        options = { cwd = process.cwd },
      },
    },
  })
  check(
    created.block_ids and #created.block_ids == 1 and created.block_ids[1],
    "new terminal identity unavailable; inspect the active tab before retrying"
  )
  unchanged(session_id, window)
  call("session.focus_block", { session_id = session_id, block_id = created.block_ids[1] })
  return created
end

local function toggle(session_id)
  local host_id = check(call("server.status", {}).host_id, "local host identity unavailable")
  local blocks = call("session.list_blocks", { session_id = session_id }).blocks or {}
  local managed
  for _, block in ipairs(blocks) do
    if block.label == label then
      check(not managed, "multiple scratch terminals found; rename the unwanted matches")
      managed = block
    end
  end
  local view = call("session.view", { session_id = session_id })
  local window = active(view)
  if not managed then
    return create(session_id, view, window, host_id)
  end
  check(
    managed.creator_name == terminal
      and managed.flavor == terminal .. ".shell"
      and managed.host_id == host_id,
    "scratch label belongs to another kind of terminal; rename it before retrying"
  )
  check(managed.placement == "placed", "scratch terminal is detached; place or rename it manually")
  local previous, layer = locate(view, managed.block_id)
  check(
    previous and layer.kind == "floating" and #layer.blocks == 1,
    "scratch must be a single-pane floating layer; restore or rename it manually"
  )
  if previous.window_id == window.window_id then
    local hide = layer.state ~= "minimized" and window.focused_block_id == managed.block_id
    return call("session.set_layer_state", {
      session_id = session_id,
      layer_id = layer.layer_id,
      state = hide and "minimized" or "normal",
      focus = not hide,
    })
  end

  local target = check(anchor(window), "destination tab needs a tiled pane")
  check(anchor(previous), "source tab needs a tiled pane so the transfer cannot close it")
  unchanged(session_id, window)
  call("session.move_block", {
    session_id = session_id,
    block_id = managed.block_id,
    anchor_block_id = target,
    direction = "horizontal",
    side = "after",
    ratio = 0.5,
  })
  -- There is no atomic cross-tab float API. Never close a shell to undo a
  -- partial transfer: leave it recoverable if floating the new split fails.
  local floated = rex.call("session.float_block", {
    session_id = session_id,
    block_id = managed.block_id,
    bounds = layer.bounds,
  })
  check(
    floated,
    "transfer stopped in a destination split; use Float Pane to recover the running shell"
  )
  call("session.focus_block", { session_id = session_id, block_id = managed.block_id })
  return floated
end

---@param ctx RexContext
---@return RexCallResult
function M.run(ctx)
  local session_id = check(ctx.session_id, "session required")
  check(not busy[session_id], "another scratch action is in progress")
  busy[session_id] = true
  local ok, result = pcall(toggle, session_id)
  busy[session_id] = nil
  if not ok then
    error(result, 0)
  end
  return result
end

function M.register()
  rex.action({
    name = "toggle_scratch",
    title = "Toggle Shared Scratch Terminal",
    category = "Pane",
    description = "Summon one persistent shell into this tab, or minimize it when focused.",
    run = M.run,
  })
end

return M
