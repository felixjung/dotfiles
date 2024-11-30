-- gitlinker
vim.keymap.set(
    { "n" },
    "<leader>gy",
    "<cmd>lua require('gitlinker').get_buf_range_url('n')<cr>",
    { desc = "Link to git repo" }
)

vim.keymap.set(
    { "v" },
    "<leader>gy",
    "<cmd>lua require('gitlinker').get_buf_range_url('v')<cr>",
    { desc = "Link to git repo with lines" }
)
