local util = require("lspconfig.util")
local mapping = require("lib.keymapping")
local nls = require("null-ls")

local ls = {
  name = "gopls",
  config = {
    cmd = { "gopls" },
    on_attach = function(client)
      client.server_capabilities.document_formatting = false
    end,
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.mod"),
  },
}

local nls_sources = {
  nls.builtins.formatting.goimports,
  nls.builtins.diagnostics.golangci_lint,
}

return {
  ls = ls,
  nls_sources = nls_sources,
}
