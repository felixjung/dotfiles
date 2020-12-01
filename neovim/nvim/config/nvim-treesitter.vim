lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["Felix Jung"] = "Identifier",
    },
    indent = {
      enable = true
    },
  },
}
EOF
