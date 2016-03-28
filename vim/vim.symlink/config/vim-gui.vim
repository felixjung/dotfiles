" Configure UI {
  " Theming
  set background=dark                            " Use dark variant of theme
  colorscheme base16-ocean                       " Set theme

  " Misc settings
  set linespace=0                                " No extra spaces between rows
  set number                                     " Line numbers on
  set showmatch                                  " Show matching brackets/parenthesis
  set winminheight=0                             " Windows can be 0 line high
  set whichwrap=b,s,h,l,<,>,[,]                  " Backspace and cursor keys wrap too
  set list                                       " Display whitespace
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Set whitespace symbols
  set foldenable                                 " Enable code folding
  set nocursorline                               " Slows down Vim too much

  " Status line
  set laststatus=2                               " Always show the status line

  " Search
  set incsearch                                  " Find as you type search
  set hlsearch                                   " Highlight search terms
  set ignorecase                                 " Case insensitive search
  set smartcase                                  " Case sensitive when uc present

  " Splits
  set splitright                                 " Puts new vsplit windows to the right of the current
  set splitbelow                                 " Puts new split windows to the bottom of the current
" }
