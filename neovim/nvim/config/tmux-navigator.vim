" Fix <ctrl-h> for pane navigation when using neovim
if has('nvim')
  nmap <bs> :<c-u>TmuxNavigateLeft<cr>
endif
