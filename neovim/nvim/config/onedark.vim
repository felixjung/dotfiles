let g:onedark_terminal_italics=1

if (has("autocmd") && !has("gui_running"))
  let s:vertsplit = { "gui": "#2C323C", "cterm": "236", "cterm16": "8" }
  autocmd ColorScheme * call onedark#set_highlight("VertSplit", { "fg": s:vertsplit }) " No `bg` setting
end
