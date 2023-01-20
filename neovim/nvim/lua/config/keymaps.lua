-- neovim/tmux navigation
vim.keymap.set({ "n", "t" }, "<C-h>", "<Cmd>NavigatorLeft<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<Cmd>NavigatorRight<CR>", { desc = "Go to right window" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<Cmd>NavigatorUp<CR>", { desc = "Go to upper window" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<Cmd>NavigatorDown<CR>", { desc = "Go to lower window" })
vim.keymap.set({ "n", "t" }, "<C-p>", "<Cmd>NavigatorPrevious<CR>", { desc = "Go to previous window" })
