return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.component_separators = ""
      opts.options.section_separators = ""
      opts.options.theme = function()
        local theme = require("catppuccin.utils.lualine")()
        local base = theme.normal.c
        for mode, sections in pairs(theme) do
          if mode ~= "inactive" then
            sections.a.fg = sections.a.bg
          end
          sections.a.bg = base.bg
          sections.a.gui = nil
          sections.b = vim.deepcopy(base)
          sections.c = vim.deepcopy(base)
        end
        return theme
      end

      local filename = {
        "filename",
        path = 1,
        symbols = { modified = "+", readonly = "󰌾" },
        cond = function()
          return vim.o.columns >= 120
        end,
      }
      local short_filename = vim.deepcopy(filename)
      short_filename.path = 0
      short_filename.cond = function()
        return vim.o.columns < 120
      end

      -- Keep LazyVim's diagnostics and trailing symbol components, but omit
      -- its project name, filetype icon, and original path component.
      local context = vim.list_slice(opts.sections.lualine_c, 5)
      local diagnostics
      for _, component in ipairs(opts.sections.lualine_c) do
        if component[1] == "diagnostics" then
          diagnostics = component
          break
        end
      end
      opts.sections.lualine_a = {
        {
          function()
            return "▎"
          end,
          padding = 0,
        },
        "mode",
      }
      opts.sections.lualine_b = {
        {
          "branch",
          color = function()
            return { fg = Snacks.util.color("Special") }
          end,
        },
      }
      opts.sections.lualine_c = { filename, short_filename }
      if diagnostics then
        table.insert(opts.sections.lualine_c, diagnostics)
      end
      for _, component in ipairs(context) do
        local cond = component.cond
        component.cond = function()
          return vim.o.columns >= 70 and (not cond or cond())
        end
        table.insert(opts.sections.lualine_c, component)
      end

      -- Preserve the existing Copilot, Noice, debugger, and update indicators.
      for _, component in ipairs(opts.sections.lualine_x) do
        if component[1] == "diff" then
          local cond = component.cond
          component.cond = function()
            return vim.o.columns >= 90 and (not cond or cond())
          end
        end
      end
      table.insert(opts.sections.lualine_x, {
        "%l:%c",
        color = function()
          return { fg = Snacks.util.color("Comment") }
        end,
      })
      opts.sections.lualine_y = {}
      opts.sections.lualine_z = {}
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_close_icon = false,
      },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          {
            icon = " ",
            title = "Keymaps",
            section = "keys",
            indent = 2,
            padding = 1,
          },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
          },
          { section = "startup" },
        },
      },
    },
    keys = {
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
      },
    },
  },
}
