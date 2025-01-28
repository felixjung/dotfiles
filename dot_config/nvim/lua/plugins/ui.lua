return {
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
                    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
                    {
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },
                    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
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
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "felixjung/tokyonight-mnml-lualine", dev = true },
        },
        opts = function()
            local icons = require("lazyvim.config").icons
            local Util = require("lazyvim.util")

            return {
                options = {
                    theme = "tokyonight-mnml",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "alpha" } },
                    component_separators = " ",
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = {
                        {
                            function()
                                return ""
                            end,
                            padding = { left = 1, right = 1 },
                        },
                    },
                    lualine_b = {
                        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    },
                    lualine_c = {
                        "branch",
                        LazyVim.lualine.root_dir(),
                        { LazyVim.lualine.pretty_path() },
                    },
                    lualine_x = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                    },
                    lualine_y = {
                        {
                            function() return require("noice").api.status.mode.get() end,
                            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                            color = function() return { fg = Snacks.util.color("Constant") } end,
                        },
                        {
                            function() return "  " .. require("dap").status() end,
                            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                            color = function() return { fg = Snacks.util.color("Debug") } end,
                        },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    lualine_z = {
                        { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
}
