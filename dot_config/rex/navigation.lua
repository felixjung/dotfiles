local M = {}
local directions = { left = true, down = true, up = true, right = true }

-- All callers identify their source; a delayed editor request must never move
-- focus from a different tab or pane. The underlying focus RPC is not atomic
-- with this check; another client can still change focus between the two.
function M.focus(ctx, direction)
  assert(directions[direction], "Navigation: invalid direction")
  assert(ctx.session_id and ctx.block_id, "Navigation: pane context required")
  local view = assert(
    rex.call("session.view", { session_id = ctx.session_id }),
    "Navigation: cannot read layout"
  )
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      if window.focused_block_id ~= ctx.block_id or window.zoomed_block_id then
        return { handled = true }
      end
      assert(
        rex.call("session.focus_direction", {
          session_id = ctx.session_id,
          direction = direction,
          wrap = false,
        }),
        "Navigation: cannot move focus"
      )
      return { handled = true }
    end
  end
  error("Navigation: active tab unavailable", 0)
end

function M.register()
  rex.action({
    name = "smart_splits_focus",
    title = "Navigate from Neovim",
    args = { direction = "string" },
    run = function(ctx, args)
      return M.focus(ctx, args.direction)
    end,
  })
  for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    rex.bind("ctrl+" .. key, function(ctx)
      if not ctx.session_id or not ctx.block_id then
        return false
      end
      local result = rex.call("com.superlogical.terminal.process", {
        session_id = ctx.session_id,
        block_id = ctx.block_id,
        args = {},
      })
      local process = result and result.foreground
      if not process or process.name == "nvim" or process.name == "vim" then
        return false
      end
      M.focus(ctx, direction)
      return true
    end)
  end
end

return M
