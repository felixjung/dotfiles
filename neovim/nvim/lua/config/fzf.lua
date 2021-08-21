local mapping = require("lib.keymapping")

-- TODO: integrate with language server etc. when done.

mapping.nnoremap("<C-t>", ":FZF<CR>")
