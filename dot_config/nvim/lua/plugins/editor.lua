return {
    {
        "mrjones2014/smart-splits.nvim",
        lazy = false,
        keys = {
            {
                "<A-h>",
                function()
                    require("smart-splits").resize_left()
                end,
                mode = { "n" },
                desc = "Resize Left",
            },
            {
                "<A-l>",
                function()
                    require("smart-splits").resize_right()
                end,
                mode = { "n" },
                desc = "Resize Right",
            },
            {
                "<A-j>",
                function()
                    require("smart-splits").resize_down()
                end,
                mode = { "n" },
                desc = "Resize Down",
            },
            {
                "<A-k>",
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
        "ruifm/gitlinker.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            add_current_line_on_normal_mode = false,
        },
    },

    {
        "echasnovski/mini.surround",
        opts = {
            mappings = {
                add = "S",     -- Add surrounding in Normal and Visual modes
                delete = "ds", -- Delete surrounding
                find = "sf",   -- Find surrounding (to the right)
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
            { "z",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
            { "Z",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
            { "gz", mode = { "n", "x", "o" }, desc = "Leap from windows" },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
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
        "nvim-telescope/telescope.nvim",
    },
}
