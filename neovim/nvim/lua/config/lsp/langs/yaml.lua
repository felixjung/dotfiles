local util = require("lspconfig.util")

local ls = {
  name = "yamlls",
  config = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_dir = util.root_pattern(".git") or dirname,
  },
}

return {
  ls = ls,
}
