local util = require("lspconfig.util")
local nls = require("null-ls")

local ls = {
  name = "gopls",
  config = {
    cmd = { "gopls" },
    on_attach = function(client, bufnr)
      -- We format with goimports via null-ls
      client.resolved_capabilities.document_formatting = false
    end,
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.mod", ".git"),
  },
}

local nls_sources = {
  nls.builtins.formatting.goimports,
}

return {
  ls = ls,
  nls_sources = nls_sources,
}
