if &compatible
  set nocompatible                              " Use Vim settings rather than Vi's
endif

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
  Plug 'Lokaltog/vim-easymotion'
  Plug 'scrooloose/nerdcommenter'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'vim-scripts/Auto-Pairs'
  Plug '~/.fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'w0rp/ale'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'fszymanski/deoplete-emoji'
  Plug 'ervandew/supertab'
" }

" Git and Github {
  Plug 'airblade/vim-gitgutter'
  Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim', { 'on': 'Gist' }
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
" }


" UI configuration {
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 'ryanoasis/vim-devicons'

" }

" Themes {
  Plug 'kaicataldo/material.vim'
" }

" tmux integration {
  Plug 'christoomey/vim-tmux-navigator'
" }

" Language support {
  " Academic work
  Plug 'JuliaLang/julia-vim', { 'for': 'julia' }

  " Javascript
  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
  Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'javascript.jsx'] }

  " Typescript
  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
  Plug 'mhartington/nvim-typescript', { 'for': 'typescript' }

  " Web
  Plug 'othree/html5.vim', { 'for': ['html', 'javascript', 'javascript.jsx'] }
  Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript', 'javascript.jsx'] }
  Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'sass', 'scss'] }
  Plug 'gorodinskiy/vim-coloresque', { 'for': ['css', 'sass', 'scss'] }
  Plug 'groenewege/vim-less', { 'for': 'less' }
  Plug 'othree/csscomplete.vim', { 'for': ['css', 'sass', 'scss'] }

  " Rust
  Plug 'cespare/vim-toml', { 'for': ['toml'] }

  " Ruby
  Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  Plug 'tpope/vim-rails', { 'for': 'ruby' }

  " Golang
  Plug 'fatih/vim-go', { 'for': 'go' }

  " Tmux configuration files
  Plug 'tmux-plugins/vim-tmux'

  " Writing
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" }

call plug#end()
