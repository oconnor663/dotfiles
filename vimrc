set termguicolors
colorscheme solarized
set background=light

set cursorline
set expandtab
set ignorecase
set list
set listchars=tab:»\ ,trail:·
set number
set shiftwidth=4
set smartcase
set tabstop=4
set updatetime=100 " reduces gitgutter lag

" Leader key is space.
let mapleader = " "
noremap <space> <nop>

" remain in visual mode when indenting or dedenting
vnoremap < <gv
vnoremap > >gv

" remap backspace to last file
nnoremap <bs> <c-^>

" a keybinding to insert a [hyper](link) in markdown
vnoremap <c-k> <esc>`>a]()<esc>`<i[<esc>/()<cr>:nohlsearch<cr>a

" common typos
command W w
command Q q
command WQ wq
command Wq wq
command WA wa
command Wa wa

" Prefer // over /*...*/. Used by vim-commentary.
" See https://stackoverflow.com/a/68813146/823869 for why we need to do
" 'filetype plugin indent on' first.
filetype plugin indent on
autocmd FileType c,cpp,cs,java setlocal commentstring=//\ %s

" Telescope bindings
nnoremap <c-t> <cmd>Telescope find_files<cr>
" finders
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fa <cmd>lua require('telescope.builtin').find_files({hidden=1, no_ignore=1})<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" goto lists on the symbol under the cursor
nnoremap <leader>gr <cmd>Telescope lsp_references<cr>
nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
" live ripgrep
nnoremap <leader>rg <cmd>Telescope live_grep<cr>
nnoremap <leader>ra <cmd>lua require('telescope.builtin').live_grep({additional_args={"--hidden", "--no-ignore"}})<cr>

" Bindings for opening new tmux windows in the current file's parent directory.
map <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux new-window -c $VIM_DIR"<cr>
" Note that tmux's notion of vertical/horizontal is opposite Vim's, and I prefer Vim's.
map <leader>ht :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux split-window -v -c $VIM_DIR"<cr>
map <leader>vt :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux split-window -h -c $VIM_DIR"<cr>

" Hop bindings
lua require'hop'.setup()
nnoremap <leader>w :HopWord<cr>
nnoremap <leader>/ :HopChar1<cr>

" TreeSitter configs
lua <<END
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "rust", "python", "go", "vim", "lua" },
  auto_install = true,
  highlight = {
    enable = true,
  },
}
END

" LSP configs
lua <<END
local lspconfig = require('lspconfig')
lspconfig.rust_analyzer.setup {
  settings = {
    ['rust-analyzer'] = {},
  },
  on_attach = function(client, bufnr)
    -- Disable semantic syntax highlighting. The only visual difference
    -- between this and Tree-sitter that I know of is that this makes all
    -- variables blue, which I don't like. Also this takes a few seconds to
    -- load. Maybe give it another shot in the future.
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
lspconfig.clangd.setup{}
lspconfig.gopls.setup{}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = buffer,
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})
END
