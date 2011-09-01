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

let g:CommandTMaxFiles=1000000
let g:CommandTMatchWindowReverse=1
let mapleader=","

syntax on
filetype on
filetype plugin on
filetype indent on

set background=dark
let g:solarized_termtrans=1
colorscheme solarized
