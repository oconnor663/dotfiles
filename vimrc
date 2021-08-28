set background=light
set completeopt=menuone,noselect " needed by nvim-compe
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
set signcolumn=auto:9 " allows gitgutter and LSP symbols to coexist
set smartcase
set tabstop=4
set termguicolors
set updatetime=100 " reduces gitgutter lag

colorscheme solarized

" remain in visual mode when indenting or dedenting
vnoremap < <gv
vnoremap > >gv

" copy yanked text to the system clipboard
vnoremap y y:let @+=@"<CR>

" map Ctrl-C to Escape in all modes
noremap  <C-c> <Esc>
noremap! <C-c> <Esc>

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
" See https://stackoverflow.com/a/68813146/823869 for why we need to do
" 'filetype plugin indent on' first.
filetype plugin indent on
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Disable tab highlights in Go files.
autocmd FileType go setlocal list&
" Disable annoying red highlight on new lines.
highlight! link goSpaceError NONE

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

" bindings for miniyank
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
map <leader>p <Plug>(miniyank-cycle)
map <leader>P <Plug>(miniyank-cycleback)

" auto-format on save
autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)

" Neovim LSP
" Adapted from: https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'clangd', 'rust_analyzer', 'gopls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" nvim-compe
" Configs taken from: https://github.com/hrsh7th/nvim-compe#vim-script-config
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true
let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true
