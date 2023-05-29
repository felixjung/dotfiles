vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}

-- require("indent_blankline").setup({
--   space = "⋅",
--   eol = "↴",
--   buftype_exclude = { "terminal", "nofile" },
--   filetype_exclude = {
--     "help",
--     "startify",
--     "dashboard",
--     "packer",
--     "neogitstatus",
--     "NvimTree",
--     "Trouble",
--   },
--   char = "│",
--   use_treesitter = false,
--   show_trailing_blankline_indent = false,
--   show_current_context = true,
--   context_patterns = {
--     "class",
--     "return",
--     "function",
--     "method",
--     "^if",
--     "^while",
--     "jsx_element",
--     "^for",
--     "^object",
--     "^table",
--     "block",
--     "case",
--     "arguments",
--     "if_statement",
--     "else_clause",
--     "jsx_element",
--     "jsx_self_closing_element",
--     "try_statement",
--     "catch_clause",
--     "import_statement",
--     "operation_type",
--   },
-- })
