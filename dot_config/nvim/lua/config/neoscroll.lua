require("neoscroll").setup({})
local map = {}

map["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "80" } }
map["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "80" } }
map["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "250" } }
map["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "250" } }

require("neoscroll.config").set_mappings(map)
