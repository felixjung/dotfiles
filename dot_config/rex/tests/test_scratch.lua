-- Run from this directory's parent: luajit tests/test_scratch.lua
local root = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*)/tests/") or "."
local label = "__rex_shared_scratch"
local terminal = "com.superlogical.terminal"
local passed = 0

local function equal(actual, expected)
  assert(actual == expected, tostring(actual) .. " ~= " .. tostring(expected))
end

local function block(id, name)
  return {
    block_id = id,
    label = name or "shell",
    creator_name = terminal,
    flavor = terminal .. ".shell",
    host_id = "host",
    placement = "placed",
  }
end

local function fixture(options)
  options = options or {}
  local source = block("source")
  local other = block("other")
  local scratch = block("scratch", label)
  local layer = {
    layer_id = "float",
    kind = "floating",
    bounds = { 0.1, 0.2, 0.6, 0.5 },
    blocks = { scratch },
    state = options.minimized and "minimized" or nil,
  }
  local first = {
    window_id = "first",
    focused_block_id = options.focused and "scratch" or "source",
    layers = { { kind = "tiled", blocks = { source } } },
  }
  local second = {
    window_id = "second",
    focused_block_id = "other",
    layers = { { kind = "tiled", blocks = { other } } },
  }
  if options.existing then
    first.layers[2] = layer
    scratch.window_id = "first"
  end
  local view =
    { active_window_id = options.transfer and "second" or "first", windows = { first, second } }
  local calls = {}
  local all = options.existing and { source, other, scratch } or { source, other }
  local handlers = {
    ["server.status"] = function()
      return { host_id = "host" }
    end,
    ["session.view"] = function()
      return view
    end,
    ["session.list_blocks"] = function()
      return { blocks = all }
    end,
    [terminal .. ".process"] = function()
      return { foreground = { pid = 123, cwd = "/project with spaces" } }
    end,
    ["session.new_layer"] = function()
      return { layer_id = "new-float", block_ids = { "new-scratch" } }
    end,
    ["session.set_layer_state"] = function()
      return {}
    end,
    ["session.move_block"] = function()
      return {}
    end,
    ["session.float_block"] = function()
      return { layer_id = "moved-float" }
    end,
    ["session.focus_block"] = function()
      return {}
    end,
  }
  -- selene: allow(incorrect_standard_library_use)
  rex = {
    action = function() end,
    call = function(method, args)
      calls[#calls + 1] = { method = method, args = args }
      assert(handlers[method], "unexpected RPC: " .. method)
      return handlers[method](args)
    end,
  }
  local module = assert(loadfile(root .. "/scratch.lua"))()
  local f = {
    module = module,
    calls = calls,
    handlers = handlers,
    view = view,
    first = first,
    second = second,
    scratch = scratch,
    layer = layer,
    all = all,
  }
  function f.run()
    return module.run({ session_id = "session", block_id = "stale" })
  end
  function f.last(method)
    for index = #calls, 1, -1 do
      if calls[index].method == method then
        return calls[index].args
      end
    end
  end
  function f.fails(pattern)
    local ok, err = pcall(f.run)
    assert(not ok, "expected failure")
    assert(tostring(err):find(pattern), tostring(err))
  end
  function f.no_mutations()
    for _, method in ipairs({
      "session.new_layer",
      "session.move_block",
      "session.float_block",
      "session.set_layer_state",
      "session.focus_block",
    }) do
      equal(f.last(method), nil)
    end
  end
  return f
end

local function test(name, run)
  local ok, err = pcall(run)
  if not ok then
    error(name .. ": " .. tostring(err), 0)
  end
  passed = passed + 1
end

test("create default shell in actual focused terminal cwd", function()
  local f = fixture()
  f.run()
  local args = f.last("session.new_layer")
  equal(args.window_id, "first")
  equal(args.focus, false)
  equal(args.bounds[1], 0.15)
  equal(args.bounds[3], 0.7)
  equal(args.layout.block.label, label)
  equal(args.layout.block.options.cwd, "/project with spaces")
  equal(args.layout.block.options.command, nil)
  equal(f.last(terminal .. ".process").block_id, "source")
  equal(f.last("session.focus_block").block_id, "new-scratch")
end)

test("focused scratch minimizes without restarting", function()
  local f = fixture({ existing = true, focused = true })
  f.run()
  equal(f.last("session.set_layer_state").state, "minimized")
  equal(f.last("session.new_layer"), nil)
end)

test("minimized scratch restores and focuses", function()
  local f = fixture({ existing = true, minimized = true })
  f.run()
  equal(f.last("session.set_layer_state").state, "normal")
  equal(f.last("session.set_layer_state").focus, true)
end)

test("visible unfocused scratch raises and focuses", function()
  local f = fixture({ existing = true })
  f.run()
  equal(f.last("session.set_layer_state").state, "normal")
  equal(f.last("session.set_layer_state").focus, true)
end)

test("transfer reuses terminal and bounds without querying cwd", function()
  local f = fixture({ existing = true, transfer = true, minimized = true })
  f.run()
  equal(f.last("session.move_block").block_id, "scratch")
  equal(f.last("session.move_block").anchor_block_id, "other")
  equal(f.last("session.float_block").block_id, "scratch")
  equal(f.last("session.float_block").bounds, f.layer.bounds)
  equal(f.last("session.focus_block").block_id, "scratch")
  equal(f.last("session.new_layer"), nil)
  equal(f.last(terminal .. ".process"), nil)
end)

test("reload rediscovers scratch", function()
  local f = fixture({ existing = true })
  f.module = assert(loadfile(root .. "/scratch.lua"))()
  f.module.run({ session_id = "session" })
  equal(f.last("session.new_layer"), nil)
  equal(f.last("session.set_layer_state").layer_id, "float")
end)

test("shell exit allows recreation", function()
  local f = fixture({ existing = true })
  f.first.layers[2] = nil
  f.all[3] = nil
  f.run()
  assert(f.last("session.new_layer"))
end)

test("unavailable cwd makes no mutations", function()
  local f = fixture()
  f.handlers[terminal .. ".process"] = function()
    return { foreground = { pid = 123 } }
  end
  f.fails("working directory")
  f.no_mutations()
end)

test("remote source makes no mutations", function()
  local f = fixture()
  f.first.layers[1].blocks[1].host_id = "remote"
  f.fails("local terminal")
  f.no_mutations()
end)

test("duplicate labels make no mutations", function()
  local f = fixture({ existing = true })
  f.all[4] = block("duplicate", label)
  f.fails("multiple")
  f.no_mutations()
end)

test("manually docked scratch stays untouched", function()
  local f = fixture({ existing = true })
  f.first.layers[2] = nil
  f.first.layers[1].blocks[2] = f.scratch
  f.fails("single%-pane floating")
  f.no_mutations()
end)

test("manually split scratch stays untouched", function()
  local f = fixture({ existing = true })
  f.layer.blocks[2] = block("manual")
  f.fails("single%-pane floating")
  f.no_mutations()
end)

test("detached scratch is preserved", function()
  local f = fixture({ existing = true })
  f.first.layers[2] = nil
  f.scratch.placement = "detached"
  f.fails("detached")
  f.no_mutations()
end)

test("transfer requires destination tiled anchor", function()
  local f = fixture({ existing = true, transfer = true })
  f.second.layers = {}
  f.fails("tiled pane")
  f.no_mutations()
end)

test("transfer cannot close source tab", function()
  local f = fixture({ existing = true, transfer = true })
  f.first.layers[1].blocks = {}
  f.fails("source tab")
  f.no_mutations()
end)

test("failed move leaves terminal intact", function()
  local f = fixture({ existing = true, transfer = true })
  f.handlers["session.move_block"] = function()
    return nil, "failure"
  end
  f.fails("move_block")
  equal(f.last("session.float_block"), nil)
  equal(f.last("session.focus_block"), nil)
end)

test("failed float reports preserved split", function()
  local f = fixture({ existing = true, transfer = true })
  f.handlers["session.float_block"] = function()
    return nil, "failure"
  end
  f.fails("split")
  equal(f.last("session.focus_block"), nil)
end)

test("failed focus preserves new shell", function()
  local f = fixture()
  f.handlers["session.focus_block"] = function()
    return nil, "failure"
  end
  f.fails("focus_block")
  assert(f.last("session.new_layer"))
end)

test("tab changes before creation abort", function()
  local f = fixture()
  f.handlers[terminal .. ".process"] = function()
    f.view.active_window_id = "second"
    return { foreground = { pid = 123, cwd = "/project" } }
  end
  f.fails("changed")
  f.no_mutations()
end)

test("action registers expected palette interface", function()
  local f = fixture()
  local action
  -- selene: allow(incorrect_standard_library_use)
  rex.action = function(value)
    action = value
  end
  f.module.register()
  equal(action.name, "toggle_scratch")
  equal(action.title, "Toggle Shared Scratch Terminal")
  equal(action.run, f.module.run)
end)

for _, enabled in ipairs({ true, false }) do
  test("configuration registration with key layer " .. tostring(enabled), function()
    fixture()
    local bindings, actions = {}, {}
    -- selene: allow(incorrect_standard_library_use)
    rex.bind = function(key, action)
      bindings[key] = action
    end
    -- selene: allow(incorrect_standard_library_use)
    rex.mode = function() end
    -- selene: allow(incorrect_standard_library_use)
    rex.action = function(action)
      actions[action.name] = action
    end
    local file = assert(io.open(root .. "/init.lua"))
    local source = file:read("*a")
    file:close()
    if not enabled then
      source = source:gsub("local enabled = true", "local enabled = false", 1)
    end
    assert(loadstring(source, "@" .. root .. "/init.lua"))()
    assert(actions.toggle_scratch, "scratch palette action missing")
    assert(actions.lazygit, "Lazygit palette action missing")
    if enabled then
      equal(bindings["ctrl+a>f"], "toggle_scratch")
      equal(bindings["ctrl+a>g"], "lazygit")
      equal(bindings["ctrl+a>ctrl+a"], "pane.send_key")
    else
      equal(next(bindings), nil)
    end
  end)
end

io.write(tostring(passed) .. " scratch tests passed\n")
