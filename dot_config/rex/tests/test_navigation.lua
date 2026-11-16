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
