return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_close_icon = false,
      },
    },
  },
  { "goolord/alpha-nvim", enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")
      local colors = require("tokyonight.colors").setup({ transform = true })
      local config = require("tokyonight.config").options

      local tokyonight = {}

      tokyonight.normal = {
        a = { bg = colors.bg_statusline, fg = colors.blue },
        b = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
        c = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.insert = {
        a = { bg = colors.bg_statusline, fg = colors.green },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.command = {
        a = { bg = colors.bg_statusline, fg = colors.yellow },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.visual = {
        a = { bg = colors.bg_statusline, fg = colors.magenta },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.replace = {
        a = { bg = colors.bg_statusline, fg = colors.red },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.terminal = {
        a = { bg = colors.bg_statusline, fg = colors.green1 },
        z = { bg = colors.bg_statusline, fg = colors.fg_sidebar },
      }

      tokyonight.inactive = {
        a = { bg = colors.bg_statusline, fg = colors.blue },
        b = { bg = colors.bg_statusline, fg = colors.fg_sidebar, gui = "bold" },
        c = { bg = colors.bg_statusline, fg = colors.fg_gutter },
        z = { bg = colors.bg_statusline, fg = colors.fg_gutter },
      }

      if config.lualine_bold then
        for _, mode in pairs(tokyonight) do
          mode.a.gui = "bold"
        end
      end

      return {
        options = {
          theme = tokyonight,
          globalstatus = true,
          disabled_filetypes = { statusline = { "alpha" } },
          component_separators = " ",
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            {
              function()
                return ""
              end,
              padding = { left = 1, right = 1 },
            },
          },
          lualine_b = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
          },
          lualine_c = {
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_y = {
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = Util.fg("Constant"),
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = Util.fg("Debug"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },
}
