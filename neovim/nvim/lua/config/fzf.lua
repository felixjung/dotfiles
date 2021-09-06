local mapping = require("lib.keymapping")

require("fzf-lua").setup({
	winopts = {
		window_on_create = function() -- nvim window options override
			vim.cmd("set winhl=Normal:Normal") -- popup bg match normal windows
		end,
	},
})

mapping.nnoremap("<C-t>", ":FzfLua files<CR>")
