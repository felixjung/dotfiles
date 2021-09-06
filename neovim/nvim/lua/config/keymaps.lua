local mapping = require("lib.keymapping")

mapping.map("", "<c-j>", "<c-w>j<c-w>_")
mapping.map("", "<c-k>", "<c-w>k<c-w>_")
mapping.map("", "<c-l>", "<c-w>l<c-w>_")
mapping.map("", "<c-h>", "<c-w>h<c-w>_")

-- Navigate visual line breaks
mapping.nnoremap("k", "gk")
mapping.nnoremap("j", "gj")
mapping.nnoremap("0", "g0")
mapping.nnoremap("$", "g$")

-- Easier access to <ESC>
mapping.inoremap("jj", "<Esc>")

-- Yank from the cursor to the end of the line, to be consistent with C and D.
mapping.nnoremap("Y", "y$")

-- Visual shifting (does not exit Visual mode)
mapping.vnoremap("<", "<gv")
mapping.vnoremap(">", ">gv")

-- Cycle buffers
mapping.map("", "<M-N>", ":bnext<CR>")
mapping.map("", "<M-P>", ":bprev<CR>")

-- Toggle search results
mapping.nmap("<Leader>/", ":set invhlsearch<CR>")

-- Undotree
mapping.nmap("<Leader>u", ":UndotreeToggle<CR>")

-- Trouble
mapping.nmap("t", ":TroubleToggle<CR>")
