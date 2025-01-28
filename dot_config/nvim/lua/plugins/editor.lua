return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			{
				"<C-A-h>",
				function()
					require("smart-splits").resize_left()
				end,
				mode = { "n" },
				desc = "Resize Left",
			},
			{
				"<C-A-l>",
				function()
					require("smart-splits").resize_right()
				end,
				mode = { "n" },
				desc = "Resize Right",
			},
			{
				"<C-A-j>",
				function()
					require("smart-splits").resize_down()
				end,
				mode = { "n" },
				desc = "Resize Down",
			},
			{
				"<C-A-k>",
				function()
					require("smart-splits").resize_up()
				end,
				mode = { "n" },
				desc = "Resize Up",
			},
			-- moving between splits
			{
				"<C-h>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<C-j>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<C-k>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<C-l>",
				function()
					require("smart-splits").move_cursor_right()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<C-\\>",
				function()
					require("smart-splits").move_cursor_previous()
				end,
				mode = { "n" },
				desc = "",
			},
			-- swapping buffers between windows
			{
				"<leader><leader>h",
				function()
					require("smart-splits").swap_buf_left()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<leader><leader>j",
				function()
					require("smart-splits").swap_buf_down()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<leader><leader>k",
				function()
					require("smart-splits").swap_buf_up()
				end,
				mode = { "n" },
				desc = "",
			},
			{
				"<leader><leader>l",
				function()
					require("smart-splits").swap_buf_right()
				end,
				mode = { "n" },
				desc = "",
			},
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
		dependencies = {
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				opts = {
					filter_rules = {
						include_current_win = false,
						autoselect_one = false,
						bo = {
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
				},
			},
		},
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
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			lazygit = {
				-- your lazygit configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
	},
}
