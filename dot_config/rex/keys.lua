return function(root)
  assert(loadfile(root .. "/scrollback.lua"))().register(root)
  local function bind(key, action, args)
    rex.bind("ctrl+a>" .. key, action, args)
  end
  bind("shift+\\", "pane.split", { direction = "right" })
  bind("-", "pane.split", { direction = "down" })
  bind("x", "pane.close")
  bind("z", "pane.zoom")
  for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
    bind(key, "pane.focus", { direction = direction })
  end
  bind("o", "pane.focus_next")
  bind(";", "pane.focus_previous")
  bind("c", "client.tab.new")
  bind("g", "lazygit")
  bind("f", "toggle_scratch")
  bind("shift+7", "client.tab.close")
  bind("n", "client.tab.next")
  bind("p", "client.tab.previous")
  for index = 1, 9 do
    bind(tostring(index), "client.tab.goto", { index = index })
  end
  bind(",", "client.tab.rename")
  bind("shift+,", "client.tab.move", { direction = "backward" })
  bind("shift+.", "client.tab.move", { direction = "forward" })
  bind("shift+w", "client.tab.move_to_new_window")
  bind("[", "client.mode.enter", { name = "scroll" })
  bind("y", "pane.copy")
  bind("]", "pane.paste")
  bind("shift+a", "pane.select_all")
  bind("r", "client.config.reload")
  bind("ctrl+a", "pane.send_key", { key = "ctrl+a" })

  assert(loadfile(root .. "/scroll.lua"))().register()
end
