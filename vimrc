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
set nojoinspaces  " Join sentences with one space, not two.

" Disable the bell.
set vb t_vb=
" gvim resets this for no good reason
" http://stackoverflow.com/a/18589653/823869
autocmd GUIEnter * set vb t_vb=

" Leader key is space.
let mapleader = " "
noremap <Space> <Nop>

" override vim-sensible, let backspace delete individual spaces
set nosmarttab

" Use <Tab> and <S-Tab> to indent lines.
inoremap <Tab> <C-o>>>
inoremap <S-Tab> <C-o><<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" Since CTRL-I and <Tab> are the same key (*sigh*), we need to unclobber the
" original CTRL-I binding.
nnoremap <leader>CTRL-I CTRL-I

" vim-sensible maps Ctrl-L to nohlsearch. Let insert mode do that too.
imap <C-l> <Esc><C-l>a

" convenient mappings for interacting with the system clipboard
noremap <leader>c "+y
noremap <leader>v :set paste<CR>"+p:set nopaste<CR>
noremap <leader>V :set paste<CR>"+P:set nopaste<CR>

" Limit line length in arc files like we do in git commits.
autocmd BufRead new-commit set textwidth=72

" Prefer // over /*...*/. Used by vim-commentary.
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" settings for Go files
autocmd FileType go call SetGoOptions()
function SetGoOptions()
  setlocal nolist
  setlocal noexpandtab
  setlocal tabstop=4
  setlocal shiftwidth=4
  nnoremap <buffer> <C-]> :GoDef<CR>
endfunction

" settings for IcedCoffeeScript
autocmd BufNewFile,BufRead *.iced call SetICSOptions()
function SetICSOptions()
  setlocal syntax=coffee
  setlocal commentstring=#\ %s
endfunction

" make WSGI files look like python
autocmd BufNewFile,BufRead *.wsgi call SetWSGIOptions()
function SetWSGIOptions()
  setlocal filetype=python
endfunction

" narrower text width in README files
autocmd BufNewFile,BufRead README* call SetREADMEOptions()
function SetREADMEOptions()
  setlocal textwidth=72
  setlocal colorcolumn=72
endfunction

" Solarized color scheme in the terminal
if $SOLARIZED == '1'
  colorscheme solarized
  set background=dark
endif

" Solarized color scheme in the gui
set guifont=Ubuntu\ Mono\ 15
if has("gui_running")
  colorscheme solarized
  set background=light
endif

" CtrlP settings
let g:ctrlp_cmd = 'CtrlPMRUFiles'
let g:ctrlp_working_path_mode = 0 " use vim's working dir

" yankstack settings
let g:yankstack_map_keys = 0 " our mappings only
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" EasyMotion settings
let g:EasyMotion_keys = "asdghklqwertyuiopzxcvbnmfj"  " get rid of ;
let g:EasyMotion_do_mapping = 0
map <Leader>w <Plug>(easymotion-bd-w)
" Make all the jump targets red
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=red

" Store all backup files centrally
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp

" fix YAML key highlighting (http://stackoverflow.com/a/22714798/823869)
autocmd FileType yaml execute
      \'syn match yamlBlockMappingKey /^\s*\zs.*\ze\s*:\%(\s\|$\)/'

" Syntastic
let g:syntastic_python_python_exec = 'python3'

" vim-airline
let g:airline_powerline_fonts = 1

" unbreak Ctrl-C in SQL files
let g:omni_sql_no_default_maps = 1
