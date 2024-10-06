local conform_util = require("conform.util")
local util = require("lspconfig.util")

local function file_exists(files)
  return function(ctx)
    return vim.fs.find(files, { path = ctx.filename, type = "file", upward = true })[1]
  end
end

return {
  -- tools
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
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
        typos_lsp = {
          init_options = {
            config = "~/.config/typos/typos.toml",
            diagnosticSeverity = "Warning",
          },
        },
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
                url = "https://www.schemastore.org/api/json/catalog.json",
                enable = true,
              },
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/prettierrc"] = ".prettierrc",
                ["https://json.schemastore.org/tsconfig"] = "tsconfig*.json",
                ["https://json.schemastore.org/vscode"] = ".vscode/settings.json",
              },
            },
          },
        },
        jsonnet_ls = {
          settings = {
            formatting = {
              -- default values
              Indent = 2,
              MaxBlankLines = 2,
              StringStyle = "single",
              CommentStyle = "slash",
              PrettyFieldNames = true,
              PadArrays = false,
              PadObjects = true,
              SortImports = false,
              UseImplicitPlus = true,
              StripEverything = false,
              StripComments = false,
              StripAllButComments = false,
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
        -- ["yaml"] = { "prettierd", "prettier" },
        ["javascriptreact"] = { "dprint", "prettierd", "prettier" },
        ["typescript"] = { "dprint", "prettierd", "prettier" },
        ["typescriptreact"] = { "dprint", "prettierd", "prettier" },
        ["go"] = { "goimports" },
        ["terraform"] = { "terraform_fmt" },
      },
      formatters = {
        prettierd = {
          condition = file_exists({
            ".prettierrc",
            ".prettierrc.js",
            "prettier.config.js",
            ".prettierrc.json",
          }),
        },
        prettier = {
          condition = file_exists({
            ".prettierrc",
            ".prettierrc.js",
            "prettier.config.js",
            ".prettierrc.json",
          }),
        },
        dprint = {
          condition = file_exists({
            "dprint.json",
            "dprint.jsonc",
            ".dprint.json",
            ".dprint.jsonc",
          }),
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
        fish = { "fish" },
        go = { "golangcilint" },
        bash = { "shellcheck" },
      },
      linters = {
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
