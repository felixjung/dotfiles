local cmp = require("cmp")

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noselect",
		keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
		keyword_length = 1,
	},

	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},

	sources = {
		{
			name = "nvim_lsp",
		},
	},
})
