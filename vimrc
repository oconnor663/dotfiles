set termguicolors
colorscheme solarized
set background=light

set cursorline
set expandtab
set ignorecase
set list
set listchars=tab:»\ ,trail:·
set notimeout " for example between <leader> and the rest of a mapping
set number
set scrolloff=1
set shiftwidth=4
set smartcase
set tabstop=4

" Keep 500 oldfiles
set shada='500,<50,s10,h

" Leader key is space.
let mapleader = " "
noremap <space> <nop>

" Make Ctrl-C behave like Escape. Normally it doesn't fire InsertLeave, which
" prevents things like Copilot from cleaning up after themselves.
lua << END
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_exec_autocmds("InsertLeave", {})
  vim.cmd.stopinsert()
end, { silent = true })
END

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

" Use whole words when opening URLs with `gx`. https://vi.stackexchange.com/a/2980/1949
let g:netrw_gx="<cWORD>"

" Telescope bindings
" most important shortcuts
nnoremap <c-t> <cmd>Telescope find_files<cr>
nnoremap g<c-t> <cmd>Telescope resume<cr>
nnoremap <c-p> <cmd>Telescope oldfiles<cr>
" general finders
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fof <cmd>Telescope oldfiles<cr>
nnoremap <leader>faf <cmd>lua require('telescope.builtin').find_files({hidden=1, no_ignore=1})<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fs <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
nnoremap <leader>fd <cmd>lua require('telescope.builtin').diagnostics({severity_limit="warn"})<cr>
nnoremap <leader>fg <cmd>Telescope git_status<cr>
nnoremap <leader>fc <cmd>Telescope command_history<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope marks<cr>
" finders based on the symbol under the cursor
nnoremap <leader>gr <cmd>Telescope lsp_references<cr>
nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>gw <cmd>Telescope grep_string<cr>
nnoremap <leader>gaw <cmd>lua require('telescope.builtin').grep_string({additional_args={"--hidden", "--no-ignore"}})<cr>
" live ripgrep
nnoremap <leader>rg <cmd>Telescope live_grep<cr>
nnoremap <leader>ra <cmd>lua require('telescope.builtin').live_grep({additional_args={"--hidden", "--no-ignore"}})<cr>
" key bindings within Telescope
lua << END
require('telescope').setup{
    defaults = {
        path_display = {"truncate"},
        mappings = {
            i = {
                ["<c-j>"] = "move_selection_next",
                ["<c-k>"] = "move_selection_previous",
                -- default mappings
                -- ["<c-c>"] = "close",
                -- ["<c-n>"] = "move_selection_next",
                -- ["<c-p>"] = "move_selection_previous",
            },
            n = {
                ["<c-c>"] = "close",
                ["<c-j>"] = "move_selection_next",
                ["<c-k>"] = "move_selection_previous",
                ["<c-n>"] = "move_selection_next",
                ["<c-p>"] = "move_selection_previous",
                ["k"] = "cycle_history_prev",
                ["j"] = "cycle_history_next",
            },
        },
    },
}
END


" Bindings for opening new tmux windows in the current file's parent directory.
map <leader>t :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux new-window -c $VIM_DIR"<cr>
" Note that tmux's notion of vertical/horizontal is opposite Vim's, and I prefer Vim's.
map <leader>ht :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux split-window -v -c $VIM_DIR"<cr>
map <leader>vt :let $VIM_DIR=expand('%:p:h')<cr>:silent exec "!tmux split-window -h -c $VIM_DIR"<cr>

" Hop bindings
lua require'hop'.setup()
nnoremap <leader>w :HopWord<cr>
nnoremap <leader>/ :HopChar1<cr>

" gitgutter configs
set updatetime=100 " reduces lag
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_removed_above_and_below = '▁▔'
let g:gitgutter_sign_modified_removed   = '│▁'

" TreeSitter configs
lua <<END
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "rust", "python", "go", "vim", "lua" },
    auto_install = true,
    highlight = {
        enable = true,
    },
}

-- nvim-treesitter-context
require'treesitter-context'.setup{
  line_numbers = true,
  multiline_threshold = 1, -- Maximum number of lines to show for a single context
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })
END

" LSP configs
lua <<END
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
vim.lsp.enable('gopls')
vim.lsp.enable('ty')

-- Global mappings.
vim.keymap.set('n', ']d', function()
    vim.diagnostic.goto_next({
        severity = { min = vim.diagnostic.severity.WARN },
    })
end)
vim.keymap.set('n', '[d', function()
    vim.diagnostic.goto_prev({
        severity = { min = vim.diagnostic.severity.WARN },
    })
end)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
    end,
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = buffer,
    callback = function()
        vim.lsp.buf.format { async = false }
    end
})

-- Show diagnostics in severity order (i.e. errors on top of warnings).
vim.diagnostic.config({ severity_sort = true })

-- Work around the colorscheme's lack of support for semantic highlighting.
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
-- https://old.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
local links = {
    ['@lsp.type.namespace'] = '@namespace',
    ['@lsp.type.type'] = '@type',
    ['@lsp.type.class'] = '@type',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.interface'] = '@type',
    ['@lsp.type.struct'] = '@structure',
    ['@lsp.type.parameter'] = '@parameter',
    ['@lsp.type.variable'] = '@variable',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.enumMember'] = '@constant',
    ['@lsp.type.function'] = '@function',
    ['@lsp.type.method'] = '@method',
    ['@lsp.type.macro'] = '@macro',
    ['@lsp.type.decorator'] = '@function',
}
for newgroup, oldgroup in pairs(links) do
    vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end
END
