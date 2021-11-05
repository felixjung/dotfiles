local mapping = require("lib.keymapping")

require("fzf-lua").setup({
  winopts = {
    hl_normal = "Normal",
    hl_border = "FloatBorder",
  },
})

mapping.nnoremap("<C-t>", ":FzfLua files<CR>")
