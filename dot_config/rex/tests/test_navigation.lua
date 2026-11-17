local function check(value)
  assert(value, "test_navigation.lua assertion failed")
end
local actions, bindings, calls = {}, {}, {}
local foreground, unavailable = "nvim", false
local focused, zoomed = "b", nil
-- selene: allow(incorrect_standard_library_use)
rex = {
  action = function(a)
    actions[a.name] = a.run
  end,
  bind = function(k, f)
    bindings[k] = f
  end,
  call = function(method, args)
    if unavailable then
      return nil
    end
    check(args.session_id == "s")
    if method == "com.superlogical.terminal.process" then
      check(args.block_id == "b")
      return { foreground = { name = foreground } }
    elseif method == "session.view" then
      return {
        active_window_id = "w",
        windows = {
          { window_id = "other", focused_block_id = "unrelated" },
          { window_id = "w", focused_block_id = focused, zoomed_block_id = zoomed },
        },
      }
    elseif method == "session.focus_direction" then
      check(args.wrap == false)
      calls[#calls + 1] = args.direction
      return {}
    end
    error("unexpected " .. method)
  end,
}
local nav = dofile("navigation.lua")
nav.register()
local ctx = { session_id = "s", block_id = "b" }
for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  foreground = "nvim"
  check(bindings["ctrl+" .. key](ctx) == false)
  check(#calls == 0)
  foreground = "fish"
  check(bindings["ctrl+" .. key](ctx) == true)
  check(table.remove(calls) == direction)
  check(actions.smart_splits_focus(ctx, { direction = direction }).handled)
  check(table.remove(calls) == direction)
end
zoomed = "b"
check(bindings["ctrl+h"](ctx))
check(actions.smart_splits_focus(ctx, { direction = "left" }).handled)
check(#calls == 0)
zoomed, focused = nil, "other"
check(actions.smart_splits_focus(ctx, { direction = "left" }).handled)
check(#calls == 0)
focused, unavailable = "b", true
check(bindings["ctrl+h"](ctx) == false)
check(not pcall(actions.smart_splits_focus, ctx, { direction = "left" }))
unavailable = false
check(not pcall(actions.smart_splits_focus, ctx, { direction = "invalid" }))
check(#calls == 0)
print("navigation routing passed")

local function leaf(id, rect)
  return { block_id = id, rect = rect }
end
local function split(axis, before, after, rect)
  return { rect = rect, split = { direction = axis, before = before, after = after, ratio = 0.5 } }
end
local a = leaf("b", { 0, 0, 0.5, 1 })
local b = leaf("c", { 0.5, 0, 0.5, 1 })
local layout = split("horizontal", a, b, { 0, 0, 1, 1 })
local resized, process, size_unavailable = {}, "fish", false
local source, zoom = "b", nil
rex.call = function(method, args)
  if method == "session.view" then
    return {
      active_window_id = "w",
      windows = {
        {
          window_id = "w",
          focused_block_id = source,
          zoomed_block_id = zoom,
          layers = { { kind = "tiled", layout = layout } },
        },
      },
    }
  elseif method == "com.superlogical.terminal.process" then
    return process and { foreground = { name = process } } or nil
  elseif method == "com.superlogical.terminal.size" then
    if size_unavailable then
      return nil
    end
    return { columns = 100, rows = 40 }
  elseif method == "session.resize_pane" then
    resized[#resized + 1] = args
    return {}
  end
  error("unexpected " .. method)
end
local function expect_resize(direction, ratio, before, after, amount)
  check(actions.smart_splits_resize(ctx, { direction = direction, amount = amount or 3 }).handled)
  local call = table.remove(resized)
  check(call and math.abs(call.ratio - ratio) < 0.000001)
  check(call.before_block_id == before and call.after_block_id == after)
  check(call.session_id == "s")
end
expect_resize("left", 0.485, "b", "c")
expect_resize("right", 0.515, "b", "c")
check(bindings["ctrl+alt+h"](ctx))
check(math.abs(table.remove(resized).ratio - 0.485) < 0.000001)
for _, name in ipairs({ "nvim", "vim", false }) do
  process = name
  check(bindings["ctrl+alt+h"](ctx) == false)
end
process = "fish"
check(bindings["ctrl+alt+h"]({}) == false)
source = "other"
check(actions.smart_splits_resize(ctx, { direction = "right", amount = 3 }).handled)
source, zoom = "b", "b"
check(actions.smart_splits_resize(ctx, { direction = "right", amount = 3 }).handled)
zoom = nil
check(actions.smart_splits_resize(ctx, { direction = "up", amount = 3 }).handled)
check(#resized == 0)
size_unavailable = true
check(not pcall(actions.smart_splits_resize, ctx, { direction = "right", amount = 3 }))
size_unavailable = false
for _, amount in ipairs({ 0, -1, 1.5, math.huge }) do
  check(not pcall(actions.smart_splits_resize, ctx, { direction = "right", amount = amount }))
end
check(not pcall(actions.smart_splits_resize, ctx, { direction = "invalid", amount = 3 }))
a.block_id, b.block_id = "c", "b"
expect_resize("left", 0.485, "c", "b")
expect_resize("right", 0.545, "c", "b", 9)
expect_resize("left", 0.005, "c", "b", 10000)
expect_resize("right", 0.995, "c", "b", 10000)
a = leaf("b", { 0, 0, 0.25, 0.5 })
b = leaf("c", { 0.25, 0, 0.25, 0.5 })
local inner = split("horizontal", a, b, { 0, 0, 0.5, 0.5 })
local lower = leaf("d", { 0, 0.5, 0.5, 0.5 })
layout = split(
  "horizontal",
  split("vertical", inner, lower, { 0, 0, 0.5, 1 }),
  leaf("e", { 0.5, 0, 0.5, 1 }),
  { 0, 0, 1, 1 }
)
expect_resize("right", 0.515, "b", "c")
expect_resize("down", 0.5375, "b", "d")
expect_resize("up", 0.4625, "b", "d")
layout = leaf("other", { 0, 0, 1, 1 })
check(actions.smart_splits_resize(ctx, { direction = "right", amount = 3 }).handled)
layout = leaf("b", { 0, 0, 1, 1 })
check(actions.smart_splits_resize(ctx, { direction = "right", amount = 3 }).handled)
check(#resized == 0)
print("resize routing and geometry passed")
