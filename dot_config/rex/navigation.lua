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

-- Return the source leaf and its deepest enclosing split on this axis.
local function find_split(node, block_id, axis)
  if not node then
    return nil
  end
  if node.block_id == block_id then
    return node
  end
  local split = node.split
  if split then
    for _, child in ipairs({ split.before, split.after }) do
      local leaf, parent = find_split(child, block_id, axis)
      if leaf then
        return leaf, parent or (split.direction == axis and node or nil)
      end
    end
  end
end

local function first_block(node)
  return node.block_id or first_block(node.split.before)
end

function M.resize(ctx, direction, amount)
  assert(directions[direction], "Resize: invalid direction")
  assert(ctx.session_id and ctx.block_id, "Resize: pane context required")
  assert(
    type(amount) == "number" and amount > 0 and amount < math.huge and amount == math.floor(amount),
    "Resize: amount must be a positive integer"
  )
  local view =
    assert(rex.call("session.view", { session_id = ctx.session_id }), "Resize: cannot read layout")
  local horizontal = direction == "left" or direction == "right"
  local axis, dimension = horizontal and "horizontal" or "vertical", horizontal and 3 or 4
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      if window.focused_block_id ~= ctx.block_id or window.zoomed_block_id then
        return { handled = true }
      end
      for _, layer in ipairs(window.layers or {}) do
        local leaf, parent = find_split(layer.layout, ctx.block_id, axis)
        if leaf then
          if not parent then
            return { handled = true }
          end
          local size = assert(
            rex.call("com.superlogical.terminal.size", {
              session_id = ctx.session_id,
              block_id = ctx.block_id,
              args = {},
            }),
            "Resize: cannot read terminal size"
          )
          local cells = horizontal and size.columns or size.rows
          assert(cells and cells > 0, "Resize: terminal has no cell grid")
          local cell = leaf.rect[dimension] / cells / parent.rect[dimension]
          assert(cell > 0 and cell < 0.5, "Resize: split has no room")
          local split = parent.split
          local sign = (direction == "left" or direction == "up") and -1 or 1
          local ratio = math.max(cell, math.min(1 - cell, split.ratio + sign * amount * cell))
          -- At a size limit, never reverse the requested direction.
          if (ratio - split.ratio) * sign > 0 then
            assert(
              rex.call("session.resize_pane", {
                session_id = ctx.session_id,
                direction = axis,
                before_block_id = first_block(split.before),
                after_block_id = first_block(split.after),
                ratio = ratio,
              }),
              "Resize: cannot move divider"
            )
          end
          return { handled = true }
        end
      end
      return { handled = true }
    end
  end
  error("Resize: active tab unavailable", 0)
end

local function outside_editor(ctx)
  if not ctx.session_id or not ctx.block_id then
    return false
  end
  local result = rex.call("com.superlogical.terminal.process", {
    session_id = ctx.session_id,
    block_id = ctx.block_id,
    args = {},
  })
  local process = result and result.foreground
  return process ~= nil and process.name ~= "nvim" and process.name ~= "vim"
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
  rex.action({
    name = "smart_splits_resize",
    title = "Resize from Neovim",
    args = { direction = "string", amount = "number" },
    run = function(ctx, args)
      return M.resize(ctx, args.direction, args.amount)
    end,
  })
  for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    rex.bind("ctrl+" .. key, function(ctx)
      if not outside_editor(ctx) then
        return false
      end
      M.focus(ctx, direction)
      return true
    end)
    rex.bind("ctrl+alt+" .. key, function(ctx)
      if not outside_editor(ctx) then
        return false
      end
      M.resize(ctx, direction, 3)
      return true
    end)
  end
end

return M
