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
  Plug 'tpope/vim-commentary'
  Plug 'terryma/vim-multiple-cursors'
  Plug '~/.fzf'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'w0rp/ale'
  Plug 'ervandew/supertab'
  Plug 'liuchengxu/vista.vim'
  Plug 'psliwka/vim-smoothie'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'windwp/nvim-autopairs'
  Plug 'nathunsmitty/nvim-ale-diagnostic', { 'branch': 'main' }
  " Better syntax highlighting
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
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
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" }

" tmux integration {
  Plug 'christoomey/vim-tmux-navigator'
" }

" Language support {
  Plug 'jjo/vim-cue', { 'for': ['cue'] }

  " Academic work
  " Plug 'JuliaLang/julia-vim', { 'for': 'julia' }

  " Terraform
  Plug 'hashivim/vim-terraform'

  " GraphQL
  Plug 'jparise/vim-graphql'

  " Rust
  Plug 'cespare/vim-toml', { 'for': ['toml'] }

  " Ruby
  " Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
  " Plug 'tpope/vim-rails', { 'for': 'ruby' }

  " Golang
  Plug 'fatih/vim-go', { 'branch': 'master', 'for': 'go', 'do': ':GoInstallBinaries' }

  " Tmux configuration files
  Plug 'tmux-plugins/vim-tmux'

  " Writing
  Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
" }

call plug#end()
