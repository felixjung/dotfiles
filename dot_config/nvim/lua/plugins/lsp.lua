local util = require("lspconfig.util")
local conform_util = require("conform.util")

local function file_exists(files)
  return function(ctx)
    return vim.fs.find(files, { path = ctx.filename, type = "file", upward = true })[1]
  end
end

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
        "selene",

        -- SQL
        "sqlfmt",

        -- Writing

        -- Go
        -- "goimports",
        -- "golangci-lint-langserver",
        -- "golangci-lint",

        -- Terraform
        "terraform-ls",

        -- TypeScript and Javascript
        "deno",
        "biome",
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
        biome = {
          root_dir = util.root_pattern("biome.json"),
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
          },
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
                prosewrap = "always",
                printWidth = 80,
              },
              validate = true,
              completion = true,
              schemaStore = {
                enable = true,
              },
              schemas = {
                ["https://spec.openapis.org/oas/3.1/schema/2021-03-02"] = "/*.openapi.yaml",
              },
            },
          },
        },
        lua_ls = {},
        vimls = {},
      },
    },
  },

  -- Linters and formatters.

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["markdown"] = { { "dprint", "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "dprint", "prettierd", "prettier" } },
        ["javascript"] = { "dprint", "prettierd", "prettier" },
        ["yaml"] = { "prettierd", "prettier" },
        ["javascriptreact"] = { "dprint", "prettierd", "prettier" },
        ["typescript"] = { "dprint", "prettierd", "prettier" },
        ["typescriptreact"] = { "dprint", "prettierd", "prettier" },
        ["go"] = { "goimports" },
        ["terraform"] = { "terraform_fmt" },
        ["sql"] = { "sqlfluff" },
      },
      formatters = {
        prettierd = {
          condition = file_exists({ ".prettierrc", ".prettierrc.js", "prettier.config.js", ".prettierrc.json" }),
        },
        prettier = {
          condition = file_exists({ ".prettierrc", ".prettierrc.js", "prettier.config.js", ".prettierrc.json" }),
        },
        dprint = {
          condition = file_exists({ "dprint.json", "dprint.jsonc", ".dprint.json", ".dprint.jsonc" }),
        },
        sqlfluff = {
          condition = false,
        },
        -- sqlfluff = {
        --   stdin = true,
        --   args = {
        --     "fix",
        --     "--dialect",
        --     "postgres",
        --     "--config",
        --     "/Users/felix/Developer/merchants/internal/repository/platform2/sql/.sqlfluff",
        --     "--force",
        --     "-",
        --   },
        --   condition = file_exists({ ".sqlfluff" }),
        -- },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
        fish = { "fish" },
        -- go = { "golangcilint" },
        bash = { "shellcheck " },
        sql = { "sqlfluff" },
      },
      linters = {
        selene = {
          condition = file_exists({ "selene.toml" }),
        },
        luacheck = {
          condition = file_exists({ ".luacheckrc" }),
        },
        sqlfluff = {
          condition = false,
        },
      },
    },
  },
}
