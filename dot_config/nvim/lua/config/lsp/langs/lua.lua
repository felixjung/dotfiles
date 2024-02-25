local nls = require("null-ls")

local nls_sources = {
  nls.builtins.formatting.stylua.with({
    condition = function(utils)
      return utils.root_has_file("stylua.toml")
    end,
  }),
  nls.builtins.diagnostics.selene.with({
    condition = function(utils)
      return utils.root_has_file("selene.toml")
    end,
  }),
}

return {
  nls_sources = nls_sources,
}
