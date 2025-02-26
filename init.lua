-- init.lua
----------------------------
-- Basic Settings
---------------------------- vim.opt.termguicolors = true              -- Enable true color vim.opt.compatible = false                -- Disable compatibility mode
vim.opt.number = true                     -- Show line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.autoindent = true                 -- Enable automatic indentation
vim.opt.backspace = "indent,eol,start"    -- Allow backspace over indents, line breaks, and start of insert
vim.opt.tags = "./tags;,tags;"            -- Search for tags in the current and parent directories
vim.cmd("syntax on")                      -- Enable syntax highlighting
vim.cmd("runtime macros/matchit.vim")     -- Enable extended % matching
vim.cmd("filetype plugin on")             -- Enable file type plugins

-- Use a per-window statusline
vim.opt.laststatus = 2

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
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

----------------------------
-- Plugin Setup using lazy.nvim
----------------------------
require("lazy").setup({

  -- Plugin Manager (optional)
  { 'folke/lazy.nvim' },

  -- Mason for managing LSPs
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

  -- Colorscheme: Everforest
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.cmd("colorscheme everforest")
    end,
  },

  -- File Explorer: neo-tree
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

  -- Linting & Formatting: ALE
  { 'dense-analysis/ale' },

  -- Fuzzy Finder: fzf and fzf.
  { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end },
  { 'junegunn/fzf.vim' },

  -- Copilot Chat Integration
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only necessary on macOS/Linux
    opts = {
      -- Customize options here, e.g. model = "gpt-4o"
    },
  },

  -- Completion Engine: nvim-cmp
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
          ["<C-y>"] = cmp.mapping.confirm({ select = false }),
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Removed lualine so that only the built-in statusline and custom tabline are used.
})

----------------------------
-- LSP Configuration
----------------------------
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K',  '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
end

require("lspconfig").ts_ls.setup { on_attach = on_attach }
require("lspconfig").pyright.setup { on_attach = on_attach }

----------------------------
-- Tree-sitter Configuration
----------------------------
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "python", "javascript", "typescript", "html", "css",
    "lua", "c"
  },
  highlight = { enable = true },
  indent = { enable = false },
}

----------------------------
-- Built-in Statusline Configuration
----------------------------
vim.opt.statusline = "%f %y %m %r %= [Ln %l/%L, Col %c] [%p%%]"

----------------------------
-- Custom Tabline Configuration
----------------------------
-- This function generates a tabline showing the buffer number and filename for all listed buffers.
function _G.my_tabline()
  local s = ""
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
      local bufname = vim.api.nvim_buf_get_name(buf)
      local filename = vim.fn.fnamemodify(bufname, ":t")
      if filename == "" then
        filename = "[No Name]"
      end
      -- Highlight the active buffer differently
      if buf == vim.api.nvim_get_current_buf() then
        s = s .. "%#TabLineSel#"
      else
        s = s .. "%#TabLine#"
      end
      -- The tab label shows the buffer number followed by the filename.
      s = s .. " %" .. buf .. "T " .. buf .. ": " .. filename .. " %X"
    end
  end
  s = s .. "%#TabLineFill#"
  return s
end

vim.o.tabline = '%!v:lua.my_tabline()'
vim.opt.showtabline = 2
