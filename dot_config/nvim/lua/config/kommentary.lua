local mapping = require("lib.keymapping")

require("kommentary.config").configure_language("default", { prefer_single_line_comments = true })

vim.g.kommentary_create_default_mappings = false

mapping.nmap("gcc", "<Plug>kommentary_line_default", {})
mapping.nmap("gc", "<Plug>kommentary_motion_default", {})
mapping.vmap("gc", "<Plug>kommentary_visual_default<C-c>", {})
