call pathogen#infect()
call pathogen#helptags()

" Load vim-sensible early so that we can override parts of it.
runtime! plugin/sensible.vim

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

" Leader key is comma.
let mapleader = ","
noremap \ ,

" Use <Tab> and <S-Tab> to indent lines.
set nosmarttab " override vim-sensible, let backspace delete individual spaces
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" insert mode is handled in the Neocomplcache bindings

" vim-sensible maps Ctrl-L to nohlsearch. Let insert mode do that too.
imap <C-l> <Esc><C-l>a

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
let g:EasyMotion_do_mapping = 0
map <Leader>w <Plug>(easymotion-bd-w)
" Make all the jump targets red
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=red

" Store all backup files centrally
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
" let the default action for tab in insert mode map to C-t/C-d
imap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<C-t>"
imap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-d>"

" gVim font
set guifont=Ubuntu\ Mono\ 15

" fix YAML key highlighting (http://stackoverflow.com/a/22714798/823869)
autocmd FileType yaml execute
      \'syn match yamlBlockMappingKey /^\s*\zs.*\ze\s*:\%(\s\|$\)/'
