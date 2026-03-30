-- return {
--   "catppuccin/nvim",
--   lazy = true,
--   name = "catppuccin",
--   opts = {
--     flavour = "auto",
--     background = {
--       light = "frappe",
--       dark = "macchiato",
--     },
--     styles = {
--       comments = { "italic" },
--       conditionals = { "italic" },
--     },
--   },
-- }

return {
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "macchiato",
			},
			transparent_background = false, -- disables setting the background color.
			float = {
				transparent = false, -- enable transparent floating windows
				solid = false, -- use solid styling for floating windows, see |winborder|
			},
			show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
			term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
			dim_inactive = {
				enabled = false, -- dims the background color of inactive window
				shade = "dark",
				percentage = 0.15, -- percentage of the shade to apply to the inactive window
			},
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
				comments = { "italic" }, -- Change the style of comments
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
				-- miscs = {}, -- Uncomment to turn off hard-coded styles
			},
			lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			color_overrides = {},
			custom_highlights = {},
			default_integrations = true,
			auto_integrations = false,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
			},
		},
	},
	-- {
	--   "folke/tokyonight.nvim",
	--   lazy = false,
	--   priority = 1000,
	--   opts = {
	--     style = "storm",
	--     light_style = "day",
	--     styles = {
	--       -- Style to be applied to different syntax groups
	--       -- Value is any valid attr-list value for `:help nvim_set_hl`
	--       comments = { italic = true },
	--       keywords = { italic = true },
	--       functions = {},
	--       variables = {},
	--       -- Background styles. Can be "dark", "transparent" or "normal"
	--       sidebars = "dark", -- style for sidebars, see below
	--       floats = "dark", -- style for floating windows
	--     },
	--     sidebars = {
	--       "qf",
	--       "help",
	--     },
	--     on_highlights = function(hl, c)
	--       -- Fix background colors for lualine use with Tokyonight.
	--       hl.NavicIconsFile = { fg = c.fg, bg = c.bg_statusline }
	--       hl.NavicIconsModule = { fg = c.yellow, bg = c.bg_statusline }
	--       hl.NavicIconsNamespace = { fg = c.fg, bg = c.bg_statusline }
	--       hl.NavicIconsPackage = { fg = c.fg, bg = c.bg_statusline }
	--       hl.NavicIconsClass = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsMethod = { fg = c.blue, bg = c.bg_statusline }
	--       hl.NavicIconsProperty = { fg = c.green1, bg = c.bg_statusline }
	--       hl.NavicIconsField = { fg = c.green1, bg = c.bg_statusline }
	--       hl.NavicIconsConstructor = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsEnum = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsInterface = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsFunction = { fg = c.blue, bg = c.bg_statusline }
	--       hl.NavicIconsVariable = { fg = c.magenta, bg = c.bg_statusline }
	--       hl.NavicIconsConstant = { fg = c.magenta, bg = c.bg_statusline }
	--       hl.NavicIconsString = { fg = c.green, bg = c.bg_statusline }
	--       hl.NavicIconsNumber = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsBoolean = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsArray = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsObject = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsKey = { fg = c.purple, bg = c.bg_statusline }
	--       hl.NavicIconsKeyword = { fg = c.purple, bg = c.bg_statusline }
	--       hl.NavicIconsNull = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsEnumMember = { fg = c.green1, bg = c.bg_statusline }
	--       hl.NavicIconsStruct = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsEvent = { fg = c.orange, bg = c.bg_statusline }
	--       hl.NavicIconsOperator = { fg = c.fg, bg = c.bg_statusline }
	--       hl.NavicIconsTypeParameter = { fg = c.green1, bg = c.bg_statusline }
	--       hl.NavicText = { fg = c.fg, bg = c.bg_statusline }
	--       hl.NavicSeparator = { fg = c.fg, bg = c.bg_statusline }
	--     end,
	--   },
	-- },
	-- {
	--   "cormacrelf/dark-notify",
	--   lazy = false,
	--   priority = 1001,
	--   init = function()
	--     require("dark_notify").run()
	--   end,
	-- },
}
