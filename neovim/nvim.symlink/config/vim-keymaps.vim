" Some useful keymaps mostly taken straight from SPF13
" (https://github.com/spf13/spf13-vim)

" Remap keys {
  " Moving in tabs and windows
  map <C-J> <C-W>j<C-W>_
  map <C-K> <C-W>k<C-W>_
  map <C-L> <C-W>l<C-W>_
  map <C-H> <C-W>h<C-W>_

  " Proper navigation for visual line breaks
  noremap k gk
  noremap j gj
  noremap 0 g0
  noremap $ g$

  " Easier access to <ESC>
  inoremap jj <Esc>

  " Disable the arrow keys
  nnoremap <Left>  <NOP>
  nnoremap <Right> <NOP>
  nnoremap <Up>    <NOP>
  nnoremap <Down>  <NOP>
  inoremap <Left>  <NOP>
  inoremap <Right> <NOP>
  inoremap <Up>    <NOP>
  inoremap <Down>  <NOP>

  " Yank from the cursor to the end of the line, to be consistent with C and D.
  nnoremap Y y$

  " Code folding options
  nmap <leader>f0 :set foldlevel=0<CR>
  nmap <leader>f1 :set foldlevel=1<CR>
  nmap <leader>f2 :set foldlevel=2<CR>
  nmap <leader>f3 :set foldlevel=3<CR>
  nmap <leader>f4 :set foldlevel=4<CR>
  nmap <leader>f5 :set foldlevel=5<CR>
  nmap <leader>f6 :set foldlevel=6<CR>
  nmap <leader>f7 :set foldlevel=7<CR>
  nmap <leader>f8 :set foldlevel=8<CR>
  nmap <leader>f9 :set foldlevel=9<CR>

  " Toggle search results
  nmap <silent> <leader>/ :set invhlsearch<CR>

  " Change Working Directory to that of the current file
  cmap cd. lcd %:p:h

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " Allow using the repeat operator with a visual selection (!)
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<CR>

  " For when you forget to sudo.. Really Write the file.
  cmap w!! w !sudo tee % >/dev/null
" }
