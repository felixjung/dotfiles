local packer = require("lib.packer")

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
}

local function plugins(use)
  use({ "wbthomason/packer.nvim", opt = true })

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
end

return packer.setup(config, plugins)
