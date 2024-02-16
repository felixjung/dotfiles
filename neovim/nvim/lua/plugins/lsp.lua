local util = require("lspconfig.util")
local lzUtil = require("lazyvim.util")

lzUtil.lsp.on_attach(function(client, _)
  if client.name == "yamlls" then
    client.server_capabilities.documentFormattingProvider = true
  end
end)

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
        ["javascriptreact"] = { "dprint", "prettierd", "prettier" },
        ["typescript"] = { "dprint", "prettierd", "prettier" },
        ["typescriptreact"] = { "dprint", "prettierd", "prettier" },
        ["go"] = { "goimports" },
        ["terraform"] = { "terraform_fmt" },
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
        -- go = { "golangcilint" },
        bash = { "shellcheck " },
      },
      linters = {
        -- golangcilint = {
        --   condition = file_exists({ ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" }),
        -- },
        selene = {
          condition = file_exists({ "selene.toml" }),
        },
        luacheck = {
          condition = file_exists({ ".luacheckrc" }),
        },
      },
    },
  },
}
