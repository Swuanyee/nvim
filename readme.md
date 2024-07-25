# Neovim Setup for Multi-Language Development

This guide provides instructions for setting up Neovim with `lazy.nvim`, various language servers, and additional plugins to support development in Python, JavaScript/TypeScript, C/C++, Swift, and Kotlin.

## Prerequisites

- Neovim (v0.5.0 or later)
- Git
- Node.js and npm (for some language servers)

## Installation Instructions

### 1. Install Neovim

#### Ubuntu
```sh
sudo apt update
sudo apt install neovim
```

#### macOS
```sh
brew install neovim
```

#### Windows
Download and install Neovim from the [official website](https://neovim.io/).

### 2. Install Git

#### Ubuntu
```sh
sudo apt install git
```

#### macOS
```sh
brew install git
```

#### Windows
Download and install Git from the [official website](https://git-scm.com/download/win).

### 3. Install Node.js and npm

#### Ubuntu
```sh
sudo apt install nodejs npm
```

#### macOS
```sh
brew install node
```

#### Windows
Download and install Node.js from the [official website](https://nodejs.org/).

### 4. Install `lazy.nvim`

```sh
git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/site/pack/lazy/start/lazy.nvim
```

### 5. Install Language Servers

#### Python (pyright)
```sh
npm install pyright
```

#### JavaScript/TypeScript (tsserver)
```sh
npm install typescript typescript-language-server
```

#### C/C++ (clangd)

##### Ubuntu
```sh
sudo apt install clangd
```

##### macOS
```sh
brew install llvm
```

##### Windows
Download and install LLVM from the [official website](https://releases.llvm.org/).

#### Swift (sourcekit-lsp)
##### macOS
Install Xcode or the Swift toolchain from [Swift.org](https://swift.org/download/).

#### Kotlin (kotlin-language-server)
Download the latest release from the [GitHub releases page](https://github.com/fwcd/kotlin-language-server/releases) and follow the installation instructions.

### 6. Configure Neovim

Create an `init.lua` file in your Neovim configuration directory:

#### Linux/macOS
```sh
mkdir -p ~/.config/nvim
vim ~/.config/nvim/init.lua
```

#### Windows
```sh
mkdir -p ~/AppData/Local/nvim
notepad ~/AppData/Local/nvim/init.lua
```

Paste the following content into `init.lua`:

```lua
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
```

### 7. Start Neovim

```sh
nvim
```

This setup provides a comprehensive development environment in Neovim with support for multiple languages including Python, JavaScript/TypeScript, C/C++, Swift, and Kotlin.

This `README.md` file includes instructions for installing the necessary tools and setting up Neovim for multi-language development on Windows, Ubuntu, and macOS. The `init.lua` configuration sets up Neovim with plugins and language servers for a robust development environment.
