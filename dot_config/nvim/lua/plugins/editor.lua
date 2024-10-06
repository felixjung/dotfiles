local Util = require("lazyvim.util")

return {
  {
    "numToStr/Navigator.nvim",
    opts = {},
    lazy = false,
  },
  {
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      add_current_line_on_normal_mode = false,
    },
  },

  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "S", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
      },
    },
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
    keys = {
      { "z", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "Z", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gz", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
  },
}
