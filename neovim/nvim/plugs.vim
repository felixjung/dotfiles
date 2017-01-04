if &compatible
  set nocompatible                              " Use Vim settings rather than Vi's
endif

" Language groups to install. Options are:
" ['academic', 'javascript', 'typescript', 'html', 'css', 'php', 'python', 'ruby', 'go']
let g:languages = ['javascript', 'typescript', 'html', 'css', 'ruby', 'elm']

" Install vim-plug automatically, if not present.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Set plugs
call plug#begin('~/.config/nvim/plugs')
" Basic editor features {
  Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'vim-scripts/YankRing.vim'
  Plug 'tpope/vim-surround'
  Plug 'jaawerth/nrun.vim'
  Plug 'Lokaltog/vim-easymotion'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'ervandew/supertab'
  Plug 'scrooloose/nerdcommenter'
  Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  Plug 'terryma/vim-multiple-cursors'
  Plug 'danro/rename.vim'
  Plug 'vim-scripts/Auto-Pairs'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install --no-update-rc --bin' }
  Plug 'rking/ag.vim'
  Plug 'junegunn/goyo.vim'
" }

" Development features {
  Plug 'neomake/neomake'
" }

" Completion {
  Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" }

" Git and Github {
  Plug 'airblade/vim-gitgutter'
  Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim', { 'on': 'Gist' }
  Plug 'tpope/vim-fugitive'
" }


" UI configuration {
  Plug 'itchyny/lightline.vim'
" }

" Themes {
  Plug 'felixjung/onedark.vim'
" }

" tmux integration {
  Plug 'christoomey/vim-tmux-navigator'
" }

" Language support {
  " Academic work
  if count(g:languages, 'academic')
    Plug 'vim-scripts/Vim-R-plugin', { 'for': 'r' }
    Plug 'JuliaLang/julia-vim', { 'for': 'julia' }
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
    Plug 'elzr/vim-json', { 'for': 'json' }
    Plug 'mustache/vim-mustache-handlebars', { 'for': 'html.handlebars' }
    Plug 'othree/javascript-libraries-syntax.vim', { 'for': 'javascript' }
    Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
    Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
    Plug 'digitaltoad/vim-jade', { 'for': ['html', 'javascript'] }
    Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
    Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
  endif

  " Typescript
  if count(g:languages, 'typescript')
    Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
    Plug 'mhartington/deoplete-typescript', { 'for': 'typescript' }
  endif

  " HTML
  if count(g:languages, 'html')
    Plug 'othree/html5.vim', { 'for': ['html', 'javascript'] }
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
    Plug 'fishbullet/deoplete-ruby', { 'for': 'ruby' }
  endif

  " Golang
  if count(g:languages, 'go')
    Plug 'fatih/vim-go', { 'for': 'go' }
  endif

  " Elm
  if count(g:languages, 'elm')
    Plug 'elmcast/elm-vim', { 'for': 'elm' }
  endif

  " Tmux configuration files
  Plug 'tmux-plugins/vim-tmux'

  " Writing
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
  " Plug 'reedes/vim-pencil'
  Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': ['tex', 'latex'] }
" }

call plug#end()
