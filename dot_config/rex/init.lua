-- Disable: change this in chezmoi source, apply init.lua, then reload Rex.
-- Disabled means no custom bindings or modes; Open Lazygit stays in the palette.
local enabled = true
local root = debug.getinfo(1, "S").source:gsub("^@", ""):match("^(.*)/")
assert(loadfile(root .. "/lazygit.lua"))().register()
if enabled then
  assert(loadfile(root .. "/keys.lua"))()(root)
end
