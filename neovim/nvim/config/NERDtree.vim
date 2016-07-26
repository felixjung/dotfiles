map <C-e> :NERDTreeToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=1
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=1
" Show NERDTree when vim starts with no open file
autocmd StdinReadPre * let s:std_in=1
let NERDTreeIgnore=[
  \ '\.DS_Store$',
  \ '\.pyc',
  \ '\~$',
  \ '\.swo$',
  \ '\.swp$',
  \ '\.git',
  \ '\.hg',
  \ '\.svn',
  \ '\.bzr'
  \ ]

