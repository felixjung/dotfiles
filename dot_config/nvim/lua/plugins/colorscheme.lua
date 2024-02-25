-- return {
--   "catppuccin/nvim",
--   lazy = true,
--   name = "catppuccin",
--   opts = {
--     flavour = "macchiato",
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
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm",
			light_style = "day",
			day_brightness = 0.3,
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
			},
			on_highlights = function(hl, c)
				-- Fix background colors for lualine use with Tokyonight.
				hl.NavicIconsFile = { fg = c.fg, bg = c.bg_statusline }
				hl.NavicIconsModule = { fg = c.yellow, bg = c.bg_statusline }
				hl.NavicIconsNamespace = { fg = c.fg, bg = c.bg_statusline }
				hl.NavicIconsPackage = { fg = c.fg, bg = c.bg_statusline }
				hl.NavicIconsClass = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsMethod = { fg = c.blue, bg = c.bg_statusline }
				hl.NavicIconsProperty = { fg = c.green1, bg = c.bg_statusline }
				hl.NavicIconsField = { fg = c.green1, bg = c.bg_statusline }
				hl.NavicIconsConstructor = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsEnum = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsInterface = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsFunction = { fg = c.blue, bg = c.bg_statusline }
				hl.NavicIconsVariable = { fg = c.magenta, bg = c.bg_statusline }
				hl.NavicIconsConstant = { fg = c.magenta, bg = c.bg_statusline }
				hl.NavicIconsString = { fg = c.green, bg = c.bg_statusline }
				hl.NavicIconsNumber = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsBoolean = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsArray = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsObject = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsKey = { fg = c.purple, bg = c.bg_statusline }
				hl.NavicIconsKeyword = { fg = c.purple, bg = c.bg_statusline }
				hl.NavicIconsNull = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsEnumMember = { fg = c.green1, bg = c.bg_statusline }
				hl.NavicIconsStruct = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsEvent = { fg = c.orange, bg = c.bg_statusline }
				hl.NavicIconsOperator = { fg = c.fg, bg = c.bg_statusline }
				hl.NavicIconsTypeParameter = { fg = c.green1, bg = c.bg_statusline }
				hl.NavicText = { fg = c.fg, bg = c.bg_statusline }
				hl.NavicSeparator = { fg = c.fg, bg = c.bg_statusline }
			end,
		},
	},
	{
		"cormacrelf/dark-notify",
		lazy = false,
		priority = 1001,
		init = function()
			require("dark_notify").run()
		end,
	},
}
