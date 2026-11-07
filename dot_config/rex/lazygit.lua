local M = {}
local terminal = "com.superlogical.terminal"

---@generic T
---@param value T?
---@param message string
---@return T
local function check(value, message)
  if not value then
    error("Open Lazygit: " .. message, 0)
  end
  return value
end

---@param method string
---@param args table
---@return RexCallResult
local function call(method, args)
  local result = rex.call(method, args)
  if not result then
    -- Server payloads may contain private filesystem details.
    error("Open Lazygit: " .. method .. " failed", 0)
  end
  return result
end

---@param session_id string
---@return string, string
local function focus(session_id)
  local view = call("session.view", { session_id = session_id })
  check(type(view.active_window_id) == "string" and view.active_window_id ~= "", "no active tab")
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      check(
        type(window.focused_block_id) == "string" and window.focused_block_id ~= "",
        "active tab has no focused pane"
      )
      return view.active_window_id, window.focused_block_id
    end
  end
  error("Open Lazygit: active tab disappeared", 0)
end

---@param session_id string
---@param host_id string
---@return {window_id: string, block_id: string, pid: integer, cwd: string}
local function source(session_id, host_id)
  local window_id, block_id = focus(session_id)
  local block =
    call("session.describe_block", { session_id = session_id, block_id = block_id }).block
  check(
    block
      and block.block_id == block_id
      and block.window_id == window_id
      and block.placement == "placed"
      and block.creator_name == terminal
      and block.host_id == host_id,
    "focused pane is not a local placed terminal"
  )
  local foreground = check(
    call(terminal .. ".process", {
      session_id = session_id,
      block_id = block_id,
      args = {},
    }).foreground,
    "foreground working directory unavailable"
  )
  check(
    foreground
      and type(foreground.pid) == "number"
      and foreground.pid > 0
      and foreground.pid == math.floor(foreground.pid)
      and type(foreground.cwd) == "string"
      and foreground.cwd:sub(1, 1) == "/",
    "foreground working directory unavailable"
  )
  return { window_id = window_id, block_id = block_id, pid = foreground.pid, cwd = foreground.cwd }
end

---@param session_id string
---@param host_id string
---@param pinned {window_id: string, block_id: string, pid: integer, cwd: string}
local function revalidate(session_id, host_id, pinned)
  local current = source(session_id, host_id)
  check(
    current.window_id == pinned.window_id
      and current.block_id == pinned.block_id
      and current.pid == pinned.pid
      and current.cwd == pinned.cwd,
    "active tab, focus or foreground process changed"
  )
end

-- Terminal cwd can fall back to home if the directory disappears. Never exec
-- Lazygit there: the shell must enter the validated path or exit. Paths are argv.
local launch = [[
cd -- "$1" || exit 1
exec "$2"
]]

---@param ctx RexContext
---@return RexCallResult
function M.run(ctx)
  local session_id = check(ctx.session_id, "session required")
  check(type(session_id) == "string" and session_id ~= "", "session required")
  local host_id = check(call("server.status", {}).host_id, "local host identity unavailable")
  check(type(host_id) == "string" and host_id ~= "", "local host identity unavailable")
  -- The invocation block can belong to a stale tab. Only the current view wins.
  local pinned = source(session_id, host_id)
  local git = check(
    rex.exec({ "/usr/bin/git", "-C", pinned.cwd, "rev-parse", "--show-toplevel" }, { timeout = 5 }),
    "foreground directory is not an accessible Git repository"
  )
  check(git.ok, "foreground directory is not an accessible Git repository")
  local repo = check(git.stdout:match("^(/[^\r\n]+)\n$"), "Git repository root unavailable")
  revalidate(session_id, host_id, pinned)

  local layer
  local ok, result = pcall(function()
    local created = call("session.new_layer", {
      session_id = session_id,
      window_id = pinned.window_id,
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = false,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = {
          cwd = repo,
          shell = "none",
          path_prepend = { "/opt/homebrew/bin", os.getenv("HOME") .. "/.local/bin" },
          command = { "/bin/sh", "-c", launch, "rex-lazygit", repo, "/opt/homebrew/bin/lazygit" },
          exit = { on_completion = true, quick_exit_threshold_ms = 0 },
        },
      }),
    })
    layer = created.layer_id
    check(
      type(layer) == "string"
        and layer ~= ""
        and created.block_ids
        and #created.block_ids == 1
        and type(created.block_ids[1]) == "string"
        and created.block_ids[1] ~= "",
      "invalid new pane identity"
    )
    revalidate(session_id, host_id, pinned)
    call("session.focus_block", { session_id = session_id, block_id = created.block_ids[1] })
    local window_id, block_id = focus(session_id)
    check(
      window_id == pinned.window_id and block_id == created.block_ids[1],
      "new pane focus changed"
    )
    return created
  end)
  if not ok then
    if layer then
      local closed = rex.call("session.close_layer", { session_id = session_id, layer_id = layer })
      check(closed, "could not close its new layer after launch failure")
    end
    error("Open Lazygit: launch aborted; source changed or new pane could not be focused", 0)
  end
  return result
end

function M.register()
  rex.action({
    name = "lazygit",
    title = "Open Lazygit",
    category = "Pane",
    description = "Open a fresh tab-local Lazygit pane at the focused terminal's Git repository root.",
    run = M.run,
  })
end

return M
