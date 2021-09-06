local util = require("lspconfig.util")
local mapping = require("lib.keymapping")
local nls = require("null-ls")

local ls = {
  name = "tsserver",
  config = {
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = function(client, bufnr)
      local ts_utils = require("nvim-lsp-ts-utils")

      -- defaults
      ts_utils.setup({
        debug = false,
        disable_commands = false,
        enable_import_on_completion = false,

        -- import all
        import_all_timeout = 5000, -- ms
        import_all_priorities = {
          buffers = 4, -- loaded buffer names
          buffer_content = 3, -- loaded buffer content
          local_files = 2, -- git files or files with relative path markers
          same_file = 1, -- add to existing import statement
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,

        -- eslint
        eslint_enable_code_actions = true,
        eslint_enable_disable_comments = true,
        eslint_bin = "eslint_d",
        eslint_enable_diagnostics = true,
        eslint_opts = {
          condition = function(utils)
            return utils.root_has_file(".eslintrc")
              or utils.root_has_file(".eslintrc.js")
              or utils.root_has_file("eslintConfig")
          end,
          diagnostics_format = "#{m} [#{c}]",
        },

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        formatter_opts = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "css",
            "scss",
            "html",
            "json",
          },
          condition = function(utils)
            return utils.root_has_file("prettier.config.js")
              or utils.root_has_file(".prettierrc")
              or utils.root_has_file(".prettierrc.js")
          end,
        },

        -- update imports on file move
        update_imports_on_move = false,
        require_confirmation_on_move = false,
        watch_dir = nil,

        -- filter diagnostics
        filter_out_diagnostics_by_severity = {},
        filter_out_diagnostics_by_code = {},
      })

      -- required to fix code action ranges and filter diagnostics
      ts_utils.setup_client(client)

      -- We use the integrated null-ls formatting.
      client.resolved_capabilities.document_formatting = false
    end,
    init_options = {
      hostInfo = "neovim",
    },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  },
}

return {
  ls = ls,
}
