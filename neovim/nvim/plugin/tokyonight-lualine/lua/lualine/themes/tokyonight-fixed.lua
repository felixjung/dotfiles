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

return tokyonight
