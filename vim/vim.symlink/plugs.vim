if &compatible
  set nocompatible                              " Use Vim settings rather than Vi's
endif

" Language groups to install. Options are:
" ['academic', 'javascript', 'html', 'css', 'php', 'python', 'ruby', 'go']
let g:languages = ['javascript', 'html', 'css', 'ruby', 'go']

" Install vim-plug automatically, if not present.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Set plugs
call plug#begin('~/.vim/plugs')
" Basic editor features {
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'vim-scripts/YankRing.vim'
  Plug 'tpope/vim-surround'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'scrooloose/nerdcommenter'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  Plug 'terryma/vim-multiple-cursors'
  Plug 'danro/rename.vim'
  Plug 'vim-scripts/Auto-Pairs'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
  Plug 'rking/ag.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/vim-easy-align'
" }

" Development features {
  Plug 'scrooloose/syntastic'

  if executable('ctags')
   Plug 'majutsushi/tagbar'
  endif
" }

" Completion {
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer' }
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" }

" Git and Github {
  Plug 'airblade/vim-gitgutter'
  Plug 'mattn/gist-vim', { 'on': 'Gist' }
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] }
" }


" UI configuration {
  Plug 'bling/vim-airline'
  " Plug 'bling/vim-bufferline'
" }

" Themes {
  Plug 'chriskempson/base16-vim'
  Plug 'vim-airline/vim-airline-themes'
  " Plug 'morhetz/gruvbox'
" }

" tmux integration {
  Plug 'christoomey/vim-tmux-navigator'
" }

" Language support {
  " Academic work
  if count(g:languages, 'academic')
    Plug 'vim-scripts/Vim-R-plugin', { 'for': 'r' }
    Plug 'JuliaLang/julia-vim', { 'for': 'r' }
  endif

  " PHP
  if count(g:languages, 'php')
    Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
  endif

  " Python
  if count(g:languages, 'python')
    " See what else might be useful for developing python
    Plug 'klen/python-mode', { 'for': 'python' }
  endif

  " Javascript
  if count(g:languages, 'javascript')
    Plug 'elzr/vim-json'
    Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'digitaltoad/vim-jade', { 'for': ['html', 'javascript'] }
    Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
  endif

  " HTML
  if count(g:languages, 'html')
    Plug 'othree/html5.vim', { 'for': ['html', 'javascript'] }
    Plug 'amirh/HTML-AutoCloseTag', { 'for': 'html' }
    Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript'] }
  endif

  " CSS/Less/Sass
  if count(g:languages, 'css')
    Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass'] }
    Plug 'gorodinskiy/vim-coloresque', { 'for': ['css', 'sass'] }
    Plug 'groenewege/vim-less', { 'for': 'less' }
    Plug 'cakebaker/scss-syntax.vim', { 'for': 'sass' }
  endif


  " Ruby
  if count(g:languages, 'ruby')
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'tpope/vim-rails', { 'for': 'ruby' }
  endif

  " Golang
  if count(g:languages, 'go')
    Plug 'fatih/vim-go', { 'for': 'go' }
  endif

  " Markdown
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': ['tex', 'latex'] }
" }

call plug#end()
