-- Verify the real isolated viewer emits copy-only OSC 52, without touching a clipboard.
local path = vim.fn.tempname()
vim.fn.writefile({ "unicode: café", "second line" }, path)
vim.env.REX_SNAPSHOT = path
local sent = {}
vim.api.nvim_ui_send = function(sequence)
  sent[#sent + 1] = sequence
end
dofile("viewer/init.lua")
assert(vim.fn.filereadable(path) == 0)
assert(vim.o.clipboard == "")
vim.api.nvim_win_set_cursor(0, { 1, 0 })
local mapping = vim.fn.maparg("yy", "n", false, true)
mapping.callback()
assert(#sent == 1)
local encoded = assert(sent[1]:match("^\027%]52;c;([A-Za-z0-9+/=]+)\027\\$"))
assert(vim.base64.decode(encoded) == "unicode: café\n")
print("isolated viewer OSC 52 copy passed")
