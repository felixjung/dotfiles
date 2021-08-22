local util = require("lspconfig.util")
local nls = require("null-ls")

local ls = {
  name = "gopls",
  config = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.mod", ".git"),
  },
}

-- TODO: add config
local nls_sources = {
  nls.builtins.formatting.goimports,
}

return {
  ls = ls,
  nls_sources = nls_sources,
}
