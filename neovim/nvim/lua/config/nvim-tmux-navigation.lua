local mapping = require("lib.keymapping")

require("nvim-tmux-navigation").setup({
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
                previous = "<C-\\>",
            }
})
