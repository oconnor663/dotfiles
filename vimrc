call pathogen#infect()
call pathogen#helptags()

set hidden
set ignorecase
set smartcase
set hlsearch
set tags=tags;/
set number
set tabstop=2
set shiftwidth=2
set expandtab
set list
set listchars=tab:»\ ,trail:·
set mouse=a
set autochdir

" custom key mappings
let mapleader = ","
noremap \ ,
" indenting keeps you in visual mode
vnoremap < <gv
vnoremap > >gv

" Prefer // over /*...*/. Used by vim-commentary.
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Solarized color scheme
set background=dark
colorscheme solarized

" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRUFiles'
" CtrlP should search from the current file's directory
let g:ctrlp_working_path_mode = 1

" yankstack settings
let g:yankstack_map_keys = 0 " our mappings only
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" Store all backup files centrally
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
