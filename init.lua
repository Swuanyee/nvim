----------------------------
-- Basic Settings
----------------------------
vim.opt.termguicolors = true              -- Enable true color support
vim.opt.compatible = false                -- Disable legacy Vi compatibility
vim.opt.number = true                     -- Show absolute line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.autoindent = true                 -- Enable automatic indentation
vim.opt.backspace = "indent,eol,start"    -- Allow natural backspace behavior
vim.opt.tags = "./tags;,tags;"            -- Search for tags in current and parent directories
vim.cmd("syntax on")                      -- Enable syntax highlighting
vim.cmd("runtime macros/matchit.vim")     -- Enable extended % matching
vim.cmd("filetype plugin on")             -- Enable filetype-specific plugins
vim.opt.laststatus = 2                    -- Always show statusline
vim.opt.tabstop = 4        	   	  -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4     		  -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true   		  -- Use spaces instead of tabs

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
----------------------------
-- Basic Settings
----------------------------
vim.opt.termguicolors = true              -- Enable true color support
vim.opt.compatible = false                -- Disable legacy Vi compatibility
vim.opt.number = true                     -- Show absolute line numbers
vim.opt.relativenumber = true             -- Show relative line numbers
vim.opt.autoindent = true                 -- Enable automatic indentation
vim.opt.backspace = "indent,eol,start"    -- Allow natural backspace behavior
vim.opt.tags = "./tags;,tags;"            -- Search for tags in current and parent directories
vim.cmd("syntax on")                      -- Enable syntax highlighting
vim.cmd("runtime macros/matchit.vim")     -- Enable extended % matching
vim.cmd("filetype plugin on")             -- Enable filetype-specific plugins
vim.opt.laststatus = 2                    -- Always show statusline

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

  -- Plugin Manager
  { 'folke/lazy.nvim' },

  -- Colorscheme: Everforest
  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.background = 'dark'
      vim.g.everforest_background = 'soft'
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

  -- LSP configuration and Treesitter
  { 'neovim/nvim-lspconfig' },
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Linting & Formatting: ALE
  { 'dense-analysis/ale' },

  -- Copilot Chat Integration
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only necessary on macOS/Linux
    opts = {},
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

  -- Telescope: Fuzzy Finder with fzf-native extension
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- Leetcode plugin (build command removed)
  {
    "kawre/leetcode.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
        -- configuration goes here
    },
  }
})

----------------------------
-- LSP Configuration (Native)
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
require("lspconfig").clangd.setup { on_attach = on_attach }
-- require("lspconfig").sourcekit.setup { on_attach = on_attach }    -- Swift
-- require("lspconfig").kotlin_language_server.setup { on_attach = on_attach } -- Kotlin

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
function _G.my_tabline()
  local s = ""
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "buflisted") then
      local bufname = vim.api.nvim_buf_get_name(buf)
      local filename = vim.fn.fnamemodify(bufname, ":t")
      if filename == "" then
        filename = "[No Name]"
      end
      if buf == vim.api.nvim_get_current_buf() then
        s = s .. "%#TabLineSel#"
      else
        s = s .. "%#TabLine#"
      end
      s = s .. " %" .. buf .. "T " .. buf .. ": " .. filename .. " %X"
    end
  end
  s = s .. "%#TabLineFill#"
  return s
end

vim.o.tabline = '%!v:lua.my_tabline()'
vim.opt.showtabline = 2

----------------------------
-- File Explorer (neo-tree) key mapping: Toggle with Ctrl+n
----------------------------
vim.api.nvim_set_keymap('n', '<C-n>', ':Neotree toggle<CR>', { noremap = true, silent = true })

----------------------------
-- Telescope Key Mappings
----------------------------
vim.api.nvim_set_keymap('n', '<leader>ff', ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ":Telescope help_tags<CR>", { noremap = true, silent = true })

----------------------------
-- set colorscheme
----------------------------
vim.cmd("colorscheme bluedolphin")
--vim.cmd('highlight Normal guibg=#025E79')
--vim.cmd('highlight Normal guibg=#003950')

-- Copilot plug in configuration
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<Tab>c", 'copilot#Accept("<CR>")', { silent = true, expr = true, noremap = true })

