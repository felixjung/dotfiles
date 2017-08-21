" Basic settings {
  set clipboard+=unnamedplus                      " Neovim works with standard pbcopy/pbpaste on OS X
  set mouse=                                      " Automatically enable mouse usage
  set mousehide                                   " Hide the mouse cursor while typing
  set shortmess+=I                                " Disable welcome message
  set shiftround                                  " Round to multiples of shift
  set noshowmode                                  " Do not show the mode in the command bar
  set noshowcmd                                   " Hide the last command
  set noru                                        " Hide the ruler in command bar
  set ttimeoutlen=50                              " Time out (ms) for key sequences
  set cole=0                                      " Show concealed text normally
  set cocu=""                                     " Don't conceal text in current line
  set virtualedit=onemore                         " Allow for cursor beyond last character
  set spelllang=en_us                             " Spelling in US English
  set history=1000                                " Store a ton of history (default is 20)
  set hidden                                      " Allow buffer switching without saving
  set shortmess+=filmnrxoOtT                      " Abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
  set concealcursor=nc                            " Don't conceal while editing
  set autoread                                    " Reload files changed outside vim"
  set visualbell                                  " No sounds
  set lazyredraw


  let mapleader=','                               " Change global leader
  let maplocalleader='_'                          " Change local leader

  syntax on                                       " Syntax highlighting
" }

" Swap files or backups {
  set noswapfile " No swap file
  set nobackup   " No automatic backups
  set nowb       " No backup on overwrite
" }

" Persistent Undo {
  if has('persistent_undo')
    let &undodir=$NVIM_ROOT.'/undo'
    set undofile
  endif
" }

" Indentation {
  " Language specific indentation should be handled using the editor
  " config plugin
  set expandtab     " Use spaces instead of tabs
  set wrap          " Wrap lines when they exceed textwidth
  set nolinebreak   " Soft-wrap long lines
  set textwidth=80  " Preferred line width
  set tabstop=2     " Width of a tab stop
  set softtabstop=2 " Width of a soft tab stop when using spaces
  set shiftwidth=2  " Indent width
" }

" Completion {
  " Taken from Yadr
  " (https://raw.githubusercontent.com/skwp/dotfiles/master/vimrc)
  " Ignore the following paths/file types
  set wildignore=*.o,*.obj,*~
  set wildignore+=*nvim/backups*
  set wildignore+=*sass-cache*
  set wildignore+=*DS_Store*
  set wildignore+=vendor/rails/**
  set wildignore+=vendor/cache/**
  set wildignore+=*.gem
  set wildignore+=log/**
  set wildignore+=tmp/**
  set wildignore+=*.png,*.jpg,*.gif"
" }

" Scrolling {
  set scrolljump=5      " Lines to scroll when cursor leaves screen
  set scrolloff=8       " Minimum lines to keep above and below cursor
  set sidescrolloff=15  " Minimum columns to keep left and right of cursor
  set sidescroll=1      " Number of columns to scroll horizontally
" }

" Install plugins using vim-plug {
  let plugfile = $NVIM_ROOT.'/plugs.vim'
  if filereadable(plugfile)
    exec 'source' plugfile
  endif
" }

" Source remaining config scripts {
  let configdir = $NVIM_ROOT.'/config'

  for fpath in split(globpath(configdir, '*.vim'), '\n')
    exe 'source' fpath
  endfor
" }
