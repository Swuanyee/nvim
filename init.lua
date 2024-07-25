-- init.lua

-- Basic settings
vim.opt.termguicolors = true              -- Set true color
vim.opt.compatible = false                -- Disable compatibility with old versions of Vim
vim.opt.number = true                     -- Show line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.autoindent = true                 -- Enable automatic indentation
vim.cmd("runtime macros/matchit.vim")     -- Enable matchit.vim for extended % matching
vim.cmd("filetype plugin on")             -- Enable file type plugins
vim.opt.backspace = "indent,eol,start"    -- Configure backspace to work more naturally
vim.opt.tags = "./tags;,tags;"            -- Set tags file path
vim.cmd("syntax on")

-- Command-line abbreviation
vim.cmd('cnoreabbrev fzf FZF')

-- Plugin setup using lazy.nvim
require("lazy").setup({
  { 'folke/lazy.nvim' },              -- Plugin manager
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd("colorscheme everforest")
    end,
  },				      -- Everforest colorscheme
  { 'neovim/nvim-lspconfig' },        -- LSP configuration
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }, -- Treesitter syntax highlighting
  { 'dense-analysis/ale' },           -- Asynchronous linting/fixing
  { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }, -- Fuzzy file finder
  { 'github/copilot.vim' }            -- GitHub Copilot for Vim
})

-- Key mappings and commands
vim.api.nvim_set_keymap('n', 'gp', ":silent %!prettier --stdin-filepath %<CR>", { noremap = true })

-- ALE (Asynchronous Lint Engine) settings
vim.g.ale_fixers = {
  python = {'autopep8'},
  javascript = {'prettier', 'eslint'},
  ['*'] = {'trim_whitespace', 'remove_trailing_lines'}
}
vim.g.ale_linters_explicit = 1
vim.g.ale_sign_error = '>>'
vim.g.ale_sign_warning = '⚠'
vim.g.ale_disable_lsp = 1

-- Ensure that the 'nvim-lspconfig' plugin is installed
local lspconfig = require('lspconfig')

-- Function to set up key bindings after the LSP attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  -- Key mappings for LSP
  -- 'gd' - Go to definition
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- 'gD' - Go to declaration
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- 'gr' - Find references
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- 'gi' - Go to implementation
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- 'K' - Hover for information
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- '<leader>rn' - Rename symbol
  buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

-- Enable the Pyright language server for Python
lspconfig.pyright.setup {
  on_attach = on_attach,
}

-- Enable the tsserver language server for JavaScript/TypeScript
lspconfig.tsserver.setup {
  on_attach = on_attach,
}

-- Enable the Clangd language server for C/C++
lspconfig.clangd.setup {
  on_attach = on_attach,
}

-- Enable the SourceKit language server for Swift
lspconfig.sourcekit.setup {
  on_attach = on_attach,
}

-- Enable the Kotlin language server for Kotlin
lspconfig.kotlin_language_server.setup {
  on_attach = on_attach,
}

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "javascript", "typescript", "html", "css", "lua", "c", "swift", "kotlin"}, -- List of parsers to install
  highlight = {
    enable = true, -- Enable syntax highlighting
  },
  indent = {
    enable = false, -- Disable indentation based on Tree-sitter
  },
}
