local packer = require("lib.packer")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
}

local function plugins(use)
  use({ "wbthomason/packer.nvim", opt = true })

  -- Function library for various plugins.
  use({ "nvim-lua/plenary.nvim" })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opt = true,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = function()
      require("config.treesitter")
    end,
  })

  use({
    "marko-cerovac/material.nvim",
    config = function()
      require("config.theme")
    end,
  })

  -- Theme: icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  -- Tmux navigation
  use({
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("config.nvim-tmux-navigation")
    end,
  })

  -- Fuzzy finder
  use({
    "junegunn/fzf",
    config = function()
      require("config.fzf")
    end,
  })

  -- File tree sidebar
  use({
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    keys = {
      "normal",
      "<C-e>",
    },
    config = function()
      require("config.tree")
    end,
  })

  -- Statusline
  use({
    "hoob3rt/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("config.lualine")
    end,
    wants = "nvim-web-devicons",
  })

  -- Language server client
  use({
    "neovim/nvim-lspconfig",
    opt = true,
    event = "BufReadPre",
    wants = { "nvim-lsp-ts-utils", "null-ls.nvim" },
    config = function()
      require("config.lsp")
    end,
    requires = {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
    },
  })

  use({ "tpope/vim-surround" })

  use({
    "hrsh7th/nvim-compe",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("config.compe")
    end,
    requires = {
      {
        "windwp/nvim-autopairs",
        config = function()
          require("config.autopairs")
        end,
      },
    },
  })
end

return packer.setup(config, plugins)
