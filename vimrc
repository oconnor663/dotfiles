set background=light
set clipboard=unnamed,unnamedplus
set cursorline
set expandtab
set hidden
set ignorecase
set list
set listchars=tab:»\ ,trail:·
set mouse=a
set nojoinspaces
set number
set scrolloff=2
set shiftwidth=4
set smartcase
set tabstop=4
set termguicolors

colorscheme solarized8

" common typos
command W w
command WQ wq
command Wq wq
command WA wa
command Wa wa
command Q q
command E e

" Leader key is space.
let mapleader = " "
noremap <Space> <Nop>

" remap backspace to last file
nnoremap <BS> <C-^>

" clear the search highlight with Ctrl-L
nnoremap <silent> <C-l> :nohlsearch<CR>
imap <C-l> <C-o><C-l>

" Founder/FZF settings
function OpenFounder()
  let l:filepath = system("founder --tmux --no-newline")
  if v:shell_error == 0
    execute "e ".fnameescape(l:filepath)
  endif
endfunction
nnoremap <C-t> :call OpenFounder()<CR>
autocmd BufEnter * call system("founder add " . fnameescape(@%))

" EasyMotion settings
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap <Leader>w <Plug>(easymotion-bd-w)

" Prefer // over /*...*/. Used by vim-commentary.
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" insert line mappings adapted from vim-unimpaired
function! s:BlankUp(count) abort
  put!=repeat(nr2char(10), a:count)
  ']+1
  silent! call repeat#set("\<Plug>unimpairedBlankUp", a:count)
endfunction
function! s:BlankDown(count) abort
  put =repeat(nr2char(10), a:count)
  '[-1
  silent! call repeat#set("\<Plug>unimpairedBlankDown", a:count)
endfunction
nnoremap <silent> [<Space> :<C-U>call <SID>BlankUp(v:count1)<CR>
nnoremap <silent> ]<Space> :<C-U>call <SID>BlankDown(v:count1)<CR>
