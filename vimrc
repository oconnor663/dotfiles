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
set tabstop=4
set shiftwidth=4
set expandtab
set list
set listchars=tab:»\ ,trail:·
set mouse=a
set wildmode=list:longest,list:full
set colorcolumn=80
set nojoinspaces  " Join sentences with one space, not two.
set noswapfile
set inccommand=split
set updatetime=100  " Faster gitgutter updates.

" Enable cursor shape changing in insert mode for Neovim.
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Disable the bell.
set vb t_vb=
" gvim resets this for no good reason
" http://stackoverflow.com/a/18589653/823869
autocmd GUIEnter * set vb t_vb=

" Leader key is space.
let mapleader = " "
noremap <Space> <Nop>

" get rid of "ex mode"
nnoremap Q <Nop>

" super awesome mapping for 'last file'
nnoremap <BS> <C-^>

" override vim-sensible, let backspace delete individual spaces
set nosmarttab

" Use <Tab> and <S-Tab> to indent lines.
" inoremap <Tab> <C-o>>>
" inoremap <S-Tab> <C-o><<
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

" Prefer # in sytemd files.
autocmd FileType systemd setlocal commentstring=#\ %s

" settings for Go files
autocmd FileType go call SetGoOptions()
function SetGoOptions()
  setlocal nolist
  setlocal noexpandtab
  setlocal tabstop=4
  setlocal shiftwidth=4
endfunction

" settings for IcedCoffeeScript
autocmd BufNewFile,BufRead *.iced call SetICSOptions()
function SetICSOptions()
  setlocal filetype=iced
  setlocal syntax=coffee
  setlocal commentstring=#\ %s
  setlocal tabstop=2
  setlocal shiftwidth=2
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

" `systemctl edit` likes to put random hex characters after .conf
autocmd BufNewFile,BufRead *.conf* call SetConfOptions()
function SetConfOptions()
  setlocal filetype=conf
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

" Founder/FZF settings
" nnoremap <C-p> :AllFiles<CR>
function OpenFounder()
  let l:filepath = system("founder --tmux --no-newline")
  if v:shell_error == 0
    execute "e ".fnameescape(l:filepath)
  endif
endfunction
nnoremap <C-t> :call OpenFounder()<CR>
autocmd BufEnter * call system("founder add " . @%)  " bad whitespace handling

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

" fix YAML key highlighting (http://stackoverflow.com/a/22714798/823869)
autocmd FileType yaml execute
      \'syn match yamlBlockMappingKey /^\s*\zs.*\ze\s*:\%(\s\|$\)/'

" Syntastic
let g:syntastic_python_python_exec = 'python3'

" vim-airline
let g:airline_powerline_fonts = 1

" unbreak Ctrl-C in SQL files
let g:omni_sql_no_default_maps = 1

" Rust
let g:rustfmt_autosave = 1
let g:rust_recommended_style = 0  " avoid setting tw=99
let g:rust_cargo_check_tests = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#rust#racer_binary='/usr/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/jacko/rust/src'
" disable the preview window
set completeopt-=preview
" Make the enter key insert a newline instead of just selecting an entry, see:
" https://github.com/Shougo/deoplete.nvim/blob/master/doc/deoplete.txt
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

" vim-go
map <Leader>b :wa<CR>:GoBuild<CR>
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_list_type = "quickfix"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
au FileType go nmap gd <Plug>(go-def)

" undotree plugin
nnoremap <leader>u :UndotreeToggle<CR>
