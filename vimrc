call pathogen#infect()
call pathogen#helptags()

" Many common settings are handled in the vim-sensible plugin.
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
set wildmode=list:longest,list:full
set colorcolumn=80

" custom key mappings
let mapleader = ","
noremap \ ,
" indenting keeps you in visual mode
vnoremap < <gv
vnoremap > >gv
" vim-sensible maps Ctrl-L to nohlsearch. Let insert mode do that too.
imap <C-L> <Esc><C-L>a
" convenient mappings for interacting with the system clipboard
noremap <leader>c "+y
noremap <leader>v :set paste<CR>"+p:set nopaste<CR>
noremap <leader>V :set paste<CR>"+P:set nopaste<CR>

" Prefer // over /*...*/. Used by vim-commentary.
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Solarized color scheme
set background=dark
colorscheme solarized

" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRUFiles'
let g:ctrlp_working_path_mode = 0 " use vim's working dir

" yankstack settings
let g:yankstack_map_keys = 0 " our mappings only
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" EasyMotion settings
let g:EasyMotion_leader_key = '<space>'

" Store all backup files centrally
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" gVim font
set guifont=Ubuntu\ Mono\ 15
