local tokyonight = require("tokyonight")

-- Material config
vim.g.material_style = "palenight"
vim.g.material_italic_comments = true
vim.g.material_italic_comments = true
vim.g.material_disable_background = true
vim.g.material_disable_terminal = true
vim.g.material_hide_eob = true

-- Tokyonight
-- vim.g.tokyonight_style = "storm"
-- vim.g.tokyonight_sidebars = {
--   "qf",
--   "vista_kind",
--   "terminal",
--   "packer",
--   "spectre_panel",
--   "NeogitStatus",
--   "help",
-- }
-- vim.g.tokyonight_cterm_colors = false
-- vim.g.tokyonight_terminal_colors = true
-- vim.g.tokyonight_italic_comments = true
-- vim.g.tokyonight_italic_keywords = true
-- vim.g.tokyonight_italic_functions = false
-- vim.g.tokyonight_italic_variables = false
-- vim.g.tokyonight_transparent = false
-- vim.g.tokyonight_hide_inactive_statusline = true
-- vim.g.tokyonight_dark_sidebar = true
-- vim.g.tokyonight_dark_float = true
-- vim.g.tokyonight_colors = {}

tokyonight.setup({
  style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  light_style = "day", -- The theme is used when the background is set to light
  transparent = false, -- Enable this to disable setting the background color
  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
  styles = {
    -- Style to be applied to different syntax groups
    -- Value is any valid attr-list value for `:help nvim_set_hl`
    comments = { italic = true },
    keywords = { italic = true },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = {
    "qf",
    "help",
    "tree",
    "vista_kind",
    "terminal",
    "packer",
    "spectre_panel",
    "NeogitStatus",
  },
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})

tokyonight.colorscheme()
