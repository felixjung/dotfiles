-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require("lualine")
local colors = require("tokyonight.colors").setup(config)

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    component_separators = "",
    section_separators = "",
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.dark3, bg = colors.bg } },
    },
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_sections = {
    lualine_c = {},
    lualine_b = {},
    lualine_a = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

-- Inserts a component in lualine_c at left section
local function insert_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function insert_right(component)
  table.insert(config.sections.lualine_x, component)
end

insert_left({
  -- mode component
  function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.blue,
      i = colors.green,
      v = colors.purple,
      [""] = colors.blue,
      V = colors.purple,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.red,
      Rv = colors.red,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)

    return ""
  end,
  color = "LualineMode",
  left_padding = 1,
})

insert_left({
  "filename",
  condition = conditions.buffer_not_empty,
  color = { fg = colors.fg },
})

insert_left({
  "filetype",
  colored = true,
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
insert_left({
  function()
    return "%="
  end,
})

insert_right({
  "diagnostics",
  sources = { "nvim_lsp" },
  symbols = { error = " ", warn = " ", info = " " },
  color_error = colors.red,
  color_warn = colors.yellow,
  color_info = colors.cyan,
})

insert_right({
  "branch",
  icon = "",
  condition = conditions.check_git_workspace,
  color = { fg = colors.dark3, gui = "bold" },
})

-- Now don't forget to initialize lualine
lualine.setup(config)
