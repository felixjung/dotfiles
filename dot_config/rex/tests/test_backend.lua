-- Runs in clean headless Neovim with the installed, locked smart-splits copy.
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/../nvim")
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/smart-splits.nvim")
local backend = require("config.rex_backend")
local spec = dofile("../nvim/lua/plugins/editor.lua")[1]
vim.env.REX_SESSION, vim.env.REX_BLOCK = nil, nil
assert(not backend.detect())
local original = { mux = { backend = "existing" } }
spec.opts(nil, original)
assert(original.mux.backend == "existing")
vim.env.REX_SESSION, vim.env.REX_BLOCK = "session:test", "block:test"
vim.env.REX_SERVER, vim.env.REX_BIN_PATH = "unix:///remote/socket", "/custom folder/rex"
assert(backend.detect())
local opts = {}
spec.opts(nil, opts)
assert(opts.mux.backend == "config.rex_backend")
local sent, fail = {}, false
vim.system = function(argv, options)
  assert(options.timeout == 1500)
  assert(argv[1] == "/custom folder/rex")
  local offset = argv[5] == "smart_splits_resize" and 1 or 0
  assert(argv[7 + offset] == "-s" and argv[8 + offset] == "session:test")
  assert(argv[9 + offset] == "-b" and argv[10 + offset] == "block:test")
  assert(vim.env.REX_SERVER == "unix:///remote/socket")
  sent[#sent + 1] = offset == 1 and (argv[6] .. "/" .. argv[7]) or argv[6]
  if fail then
    error("missing CLI")
  end
  return {
    wait = function()
      return { code = 0, stdout = '{"handled":true}' }
    end,
  }
end
vim.notify_once = function() end
local splits = require("smart-splits")
splits.setup(opts)
assert(require("smart-splits.backend").resolve().name == "Rex")
vim.cmd("vsplit")
local left = vim.api.nvim_get_current_win()
splits.move_cursor_right()
assert(vim.api.nvim_get_current_win() ~= left and #sent == 0)
splits.move_cursor_right()
assert(table.remove(sent) == "direction=right")
splits.move_cursor_left()
assert(vim.api.nvim_get_current_win() == left and #sent == 0)
splits.move_cursor_left()
assert(table.remove(sent) == "direction=left")
vim.cmd("only | split")
local top = vim.api.nvim_get_current_win()
splits.move_cursor_down()
assert(vim.api.nvim_get_current_win() ~= top and #sent == 0)
splits.move_cursor_down()
assert(table.remove(sent) == "direction=down")
splits.move_cursor_up()
assert(vim.api.nvim_get_current_win() == top and #sent == 0)
splits.move_cursor_up()
assert(table.remove(sent) == "direction=up")
fail = true
splits.move_cursor_up()
assert(vim.api.nvim_get_current_win() == top)
assert(table.remove(sent) == "direction=up")
vim.wait(10)
print("smart-splits backend integration passed")

fail = false
vim.cmd("only | vsplit")
local width = vim.api.nvim_win_get_width(0)
splits.resize_right()
assert(vim.api.nvim_win_get_width(0) ~= width and #sent == 0)
splits.resize_down()
assert(table.remove(sent) == "direction=down/amount=3")
vim.cmd("only | split")
local height = vim.api.nvim_win_get_height(0)
splits.resize_down()
assert(vim.api.nvim_win_get_height(0) ~= height and #sent == 0)
splits.resize_left()
assert(table.remove(sent) == "direction=left/amount=3")
vim.cmd("only")
vim.keymap.set("n", "<F6>", splits.resize_right)
vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("3<F6>", true, false, true), "xt", false)
assert(table.remove(sent) == "direction=right/amount=9")
fail = true
assert(backend.resize("up", { amount = 6 }))
assert(table.remove(sent) == "direction=up/amount=6")
vim.wait(10)
print("smart-splits resize integration passed")
