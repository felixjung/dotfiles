" Some useful keymaps mostly taken straight from SPF13
" (https://github.com/spf13/spf13-vim)

" Remap keys {
  " Moving in tabs and windows
  map <C-J> <C-W>j<C-W>_
  map <C-K> <C-W>k<C-W>_
  map <C-L> <C-W>l<C-W>_
  map <C-H> <C-W>h<C-W>_

  " Terminal mode mappings
  tnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  tnoremap <silent> <c-j> :TmuxNavigateDown<cr>
  tnoremap <silent> <c-k> :TmuxNavigateUp<cr>
  tnoremap <silent> <c-l> :TmuxNavigateRight<cr>
  tnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
  tnoremap <Esc> <C-\><C-n>

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

  " Cycle buffers
  nnoremap <A-N> :bnext<CR>
  nnoremap <A-P> :bprev<CR>

  " Use tab for trigger completion with characters ahead and navigate.
  " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
" }
