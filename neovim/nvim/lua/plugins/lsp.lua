local util = require("lspconfig.util")
local lzUtil = require("lazyvim.util")

lzUtil.on_attach(function(client, _)
  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
  end
end)

return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua
        "stylua",
        "luacheck",
        "lua-language-server",

        -- Writing

        -- Go
        "goimports",
        "golangci-lint-langserver",
        "golangci-lint",

        -- TypeScript and Javascript
        "deno",
        "rome",
        "prettierd",

        -- Shell
        "shellcheck",
        "shfmt",
      },
    },
  },

  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    config = {
      import = {
        vscode = false,
        coc = false,
        nlsp = false,
      },
    },
    dependencies = { "nvim-lspconfig" },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        underline = false,
      },
      servers = {
        ansiblels = {},
        bashls = {},
        cssls = {},
        dockerls = {},
        tsserver = {
          root_dir = util.root_pattern("tsconfig.json"),
        },
        denols = {
          root_dir = util.root_pattern("deno.json", "deno.jsonc"),
        },
        eslint = {
          root_dir = util.root_pattern(".eslintrc.json", ".eslintrc.js"),
        },
        rome = {
          root_dir = util.root_pattern("rome.json"),
        },
        html = {},
        golangci_lint_ls = {},
        gopls = {},
        terraformls = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              redhat = { telemetry = { enabled = false } },
              format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = false,
                prosewrap = "Preserve",
                printWidth = 80,
              },
              validate = true,
              completion = true,
              schemaStore = {
                enable = true,
              },
            },
          },
        },
        lua_ls = {},
        vimls = {},
      },
    },
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        save_after_format = true,
        sources = {
          nls.builtins.formatting.prettierd.with({
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "markdown" },
            condition = function(utils)
              return utils.root_has_file({
                ".prettierrc",
                ".prettierrc.json",
                ".prettierrc.js",
                "prettier.config.js",
                ".prettierrc.yaml",
              })
            end,
          }),
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.selene.with({
            condition = function(utils)
              return utils.root_has_file({ "selene.toml" })
            end,
          }),
          nls.builtins.code_actions.gitsigns,
          nls.builtins.formatting.isort,
          nls.builtins.formatting.black,
          nls.builtins.formatting.goimports,
        },
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git", "Makefile"),
      })
    end,
  },
}
