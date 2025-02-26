-- init.lua

----------------------------
-- Basic Settings
----------------------------
vim.opt.termguicolors = true              -- Enable true color
vim.opt.compatible = false                -- Disable compatibility mode
vim.opt.number = true                     -- Show line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.autoindent = true                 -- Enable automatic indentation
vim.opt.backspace = "indent,eol,start"    -- Allow backspace over indents, line breaks, and start of insert
vim.opt.tags = "./tags;,tags;"            -- Search for tags in the current and parent directories
vim.cmd("syntax on")                      -- Enable syntax highlighting
vim.cmd("runtime macros/matchit.vim")     -- Enable extended % matching
vim.cmd("filetype plugin on")             -- Enable file type plugins

-- Command-line abbreviation
vim.cmd('cnoreabbrev fzf FZF')

----------------------------
-- Lazy.nvim Bootstrapping
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

----------------------------
-- Plugin Setup using lazy.nvim
----------------------------
require("lazy").setup({

  -- Plugin Manager
  { 'folke/lazy.nvim' },

  -- Mason for managing LSPs (force load on startup)
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
  },

  -- Colorscheme
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd("colorscheme everforest")
    end,
  },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },

  -- LSP and Treesitter
  { 'neovim/nvim-lspconfig' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Linting & Formatting
  { 'dense-analysis/ale' },

  -- Fuzzy Finder
  { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end },
  { 'junegunn/fzf.vim' },

  -- GitHub Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = { enabled = true },
        suggestion = { enabled = true, auto_trigger = true },
        filetypes = { ["*"] = true },
      })
    end,
  },

  -- Copilot Completion with LSP
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- Completion Engine (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          -- Use Ctrl-y to confirm a selection
          ["<C-y>"] = cmp.mapping.confirm({ select = false }),
          -- Use arrow keys for navigation
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "copilot" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Lualine for Statusline and Tabline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
})

----------------------------
-- LSP Configuration
----------------------------
local lspconfig = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  
  -- LSP Keybindings
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

-- Configure language servers
require("lspconfig").tsserver.setup { on_attach = on_attach }
require("lspconfig").pyright.setup { on_attach = on_attach }

----------------------------
-- Tree-sitter Configuration
----------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "python", "javascript", "typescript", "html", "css",
    "lua", "c", "swift", "kotlin"
  },
  highlight = { enable = true },
  indent = { enable = false },
}

----------------------------
-- Lualine Configuration (Statusline & Tabline)
----------------------------
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'everforest',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {
      { 'buffers', mode = 2 }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        fmt = function(name, context)
          return string.format("%d: %s", context.bufnr, name)
        end,
      },
    },
    lualine_b = {'windows'},
  },
  extensions = {'fzf', 'nvim-tree', 'quickfix'}
}

----------------------------
-- GitHub Copilot Key Mapping
----------------------------
-- (Optional) Map a key for accepting Copilot suggestions via copilot-cmp if desired.
-- For instance, you might keep a mapping like <Tab>c for copilot if you want it separately:
vim.keymap.set("i", "<Tab>c", require("copilot.suggestion").accept, { silent = true })

