call pathogen#infect()
call pathogen#helptags()

set nocompatible
set hidden
set history=1000
set wildmenu
set wildmode=list:longest
set ignorecase 
set smartcase
set ruler
set hlsearch
set incsearch
set tags=tags;/
set number
set tabstop=2
set shiftwidth=2
set expandtab

syntax on
filetype on
filetype plugin on
filetype indent on

set background=dark
colorscheme solarized

" CtrlP should search from the current file's directory
let g:ctrlp_working_path_mode = 1
