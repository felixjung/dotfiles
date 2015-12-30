" Settings for editing javascript
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal textwidth=80
setlocal spell
setlocal nonumber
setlocal colorcolumn=0
setlocal formatoptions=t1

" Enable auto reformatting in insert mode
augroup PROSE
  autocmd InsertEnter * set formatoptions+=a
  autocmd InsertLeave * set formatoptions-=a
augroup END

" Map to reflow current paragraph
noremap Q gqip

