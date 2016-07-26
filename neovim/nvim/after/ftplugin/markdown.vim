" Settings for editing javascript
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=80
setlocal spell
setlocal nonumber
setlocal colorcolumn=0
setlocal conceallevel=0

" Reflow paragraph keymap
nnoremap Q gqap

" Hightlight unnecessary white space
:highlight RedundantWhitespace ctermbg=darkred guibg=darkred
:match RedundantWhitespace /\S\s\s\+\S/

" Load custom ultisnips, if plugin is installed
if exists(':UltiSnipsAddFiletypes')
  :UltiSnipsAddFiletypes markdown
  :UltiSnipsAddFiletypes markdown-github
endif
