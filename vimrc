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
set list
set listchars=trail:·
set autochdir

" custom key mappings
let mapleader = ","
noremap \ ,
noremap <C-l> :let @/ = ""<CR><C-l>

" Solarized color scheme
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

" NERDTree settings
map <Leader>t :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
" quit vim if NERDTree is the last thing open
autocmd bufenter * if (winnr("$") == 1 &&
                     \ exists("b:NERDTreeType") &&
                     \ b:NERDTreeType == "primary")
                   \ | q | endif

" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRUFiles'
" CtrlP should search from the current file's directory
let g:ctrlp_working_path_mode = 1

" Syntax highlighting
syntax on
filetype on
filetype plugin on
filetype indent on

" Store all backup files centrally
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
