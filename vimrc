set termguicolors
colorscheme solarized
set background=light

set cursorline
set ignorecase
set list
set listchars=tab:»\ ,trail:·
set number
set smartcase
set updatetime=100 " reduces gitgutter lag

" Leader key is space.
let mapleader = " "
noremap <space> <nop>

" remap backspace to last file
nnoremap <bs> <c-^>

" clear the search highlight with Ctrl-L
nnoremap <silent> <c-l> :nohlsearch<cr>
imap <c-l> <c-o><c-l>

" common typos
command W w
command Q q
command WQ wq
command Wq wq
command WA wa
command Wa wa

" Telescope bindings
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>o <cmd>Telescope oldfiles<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>s <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap gr <cmd>Telescope lsp_references<cr>
nnoremap gi <cmd>Telescope lsp_implementations<cr>

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
