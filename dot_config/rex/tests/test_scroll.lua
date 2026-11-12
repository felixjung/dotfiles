local actions, bindings, queued, modes = {}, {}, {}, {}
local screen, process, fail = "primary", nil, false
local status
-- selene: allow(incorrect_standard_library_use)
rex = {
  action = function(a)
    actions[a.name] = a.run
  end,
  bind = function(k, a)
    bindings[k] = a
  end,
  mode = function(k, options)
    modes[k] = options
  end,
  client = {
    queue = function(a, args)
      queued[#queued + 1] = { a, args }
    end,
  },
  call = function(method)
    if fail then
      return nil
    end
    if method:match("modes$") then
      return { screen = screen }
    end
    if method:match("program_status$") then
      return status
    end
    return process
  end,
}
local function check(value)
  assert(value, "scroll assertion failed")
end
local module = dofile("scroll.lua")
module.register()
local ctx = { session_id = "s", block_id = "b", client_id = "c" }
local function press(mode, key, expected, sent)
  queued = {}
  actions[bindings[mode .. "/" .. key]](ctx)
  check(#queued == 1)
  check(queued[1][1] == expected)
  check((queued[1][2] or {}).key == sent)
end
for _, identity in ipairs({ "go", "fish", "codex", "pi" }) do
  process = { foreground = { path = "/bin/" .. identity } }
  press("scroll", "ctrl+u", "client.scroll.page_up")
  press("scroll", "ctrl+d", "client.scroll.page_down")
end
screen = "alternate"
for _, identity in ipairs({ "pi", "codex" }) do
  process = { foreground = { path = "/bin/" .. identity } }
  for _, key in ipairs({ "ctrl+u", "ctrl+b" }) do
    press(
      "scroll",
      key,
      "pane.send_key",
      identity == "pi" and key == "ctrl+u" and "ctrl+pageup" or "pageup"
    )
  end
  for _, key in ipairs({ "ctrl+d", "ctrl+f" }) do
    press(
      "scroll",
      key,
      "pane.send_key",
      identity == "pi" and key == "ctrl+d" and "ctrl+pagedown" or "pagedown"
    )
  end
end
process = { foreground = { path = "/bin/op" }, ancestors = { { path = "/bin/codex" } } }
press("scroll", "ctrl+u", "client.scroll.page_up")
fail = true
press("scroll", "ctrl+d", "client.scroll.page_down")
press("scroll-pi", "ctrl+u", "pane.send_key", "ctrl+pageup")
press("scroll-codex", "ctrl+d", "pane.send_key", "pagedown")
press("scroll-terminal", "ctrl+b", "client.scroll.page_up")
for mode, options in pairs(modes) do
  check(options.exclusive)
  check(bindings[mode .. "/e"] == "scrollcopy")
  check(bindings[mode .. "/q"] == nil)
  check(bindings[mode .. "/pageup"] == nil)
  check(bindings[mode .. "/pagedown"] == nil)
  check(bindings[mode .. "/esc"] == "client.mode.exit")
  for key, target in pairs({
    a = "scroll",
    t = "scroll-terminal",
    p = "scroll-pi",
    c = "scroll-codex",
  }) do
    queued = {}
    actions[bindings[mode .. "/" .. key]](ctx)
    check(#queued == 2 and queued[1][1] == "client.mode.exit")
    check(queued[2][1] == "client.mode.enter" and queued[2][2].name == target)
  end
end
check(
  module.route("alternate", { foreground = { script = "/lib/pi-coding-agent/dist/cli.js" } })
    == "pi"
)
check(module.route("alternate", nil) == "terminal")
print("Scroll routing and profile tests passed")
fail = false
screen = "alternate"
process = { foreground = { pid = 123, name = "op", path = "/bin/op" } }
for _, app in ipairs({ "pi", "codex" }) do
  status = { records = { { app = app, owner = { pid = 123, name = "op" }, state = "idle" } } }
  press("scroll", "ctrl+u", "pane.send_key", app == "pi" and "ctrl+pageup" or "pageup")
  screen = "primary"
  press("scroll", "ctrl+u", "client.scroll.page_up")
  screen = "alternate"
end
for _, record in ipairs({
  { app = "codex", owner = { pid = 124, name = "op" } },
  { app = "codex", owner = { pid = 123, name = "fish" } },
  { app = "codex" },
  { app = "pi", id = "child", owner = { pid = 123, name = "op" } },
}) do
  status = { records = { record } }
  press("scroll", "ctrl+u", "client.scroll.page_up")
end
print("Wrapped agent and stale status tests passed")
