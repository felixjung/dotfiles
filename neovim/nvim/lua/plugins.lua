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
    "folke/tokyonight.nvim",
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

  -- File tree sidebar
  use({
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("config.tree")
    end,
  })

  use({
    "L3MON4D3/LuaSnip",
    wants = { "friendly-snippets" },
    config = function()
      require("config.luasnip")
    end,
    requires = {
      "rafamadriz/friendly-snippets",
    },
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

  use({
    "windwp/nvim-autopairs",
    config = function()
      require("config.autopairs")
    end,
  })

  -- Autocompletion with nvim-cmp
  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.cmp")
    end,
    wants = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "friendly-snippets",
    },
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
    },
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
    "b3nj5m1n/kommentary",
    opt = true,
    wants = "nvim-ts-context-commentstring",
    keys = { "gc", "gcc" },
    config = function()
      require("config.kommentary")
    end,
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
  })

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns")
    end,
  })

  use({
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  })

  -- Indent Guides and rainbow brackets
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("config.blankline")
    end,
  })

  -- Smooth Scrolling
  use({
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = function()
      require("config.neoscroll")
    end,
  })

  use({ "npxbr/glow.nvim", cmd = "Glow" })

  use({
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = { "folke/twilight.nvim" },
    config = function()
      require("zen-mode").setup({
        plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
      })
    end,
  })

  use({
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = function()
      require("config.todo")
    end,
  })

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({ auto_open = false })
    end,
  })

  use({
    "ibhagwan/fzf-lua",
    requires = {
      "vijaymarupudi/nvim-fzf",
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("config.fzf")
    end,
  })
end

return packer.setup(config, plugins)
