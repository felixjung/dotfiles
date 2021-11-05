local luasnip = require("luasnip")

luasnip.snippets = {
  go = {},
  typescript = {},
  javascript = {},
}

require("luasnip.loaders.from_vscode").load({ paths = "", include = { "go", "typescript", "javascript" } })
-- require("luasnip/loaders/from_vscode").lazy_load()
