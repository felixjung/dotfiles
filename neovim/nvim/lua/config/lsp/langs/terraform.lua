local util = require("lspconfig.util")
local nls = require("null-ls")

local ls = {
  name = "terraformls",
  config = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "tf" },
    root_dir = util.root_pattern(".terraform"),
    on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
    end,
  },
}

local nls_sources = {
  nls.builtins.formatting.terraform_fmt.with({
    command = "terraform",
    args = { "fmt", "-" },
    filetypes = { "tf", "hcl", "terraform" },
  }),
}

return {
  ls = ls,
  nls_sources = nls_sources,
}
