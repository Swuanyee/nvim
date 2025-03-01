# Neovim Setup for Multi-Language Development

## Prerequisites

- **Neovim** (v0.8.0+ for best experience | v0.10 for better integration with TMUX)
- **Git**
- **Node.js and npm** (required for some language servers)

---

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
sudo apt install git ```

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

Clone lazy.nvim into your Neovim data directory:
```sh
git clone https://github.com/folke/lazy.nvim.git ~/.local/share/nvim/site/pack/lazy/start/lazy.nvim
```

### 5. Install Language Servers Manually

Since Mason is removed from the configuration, you’ll need to install language servers manually. Ensure that the installed servers are in your system’s PATH.

- **Python (pyright)**
  ```sh
  npm install -g pyright
  ```
- **JavaScript/TypeScript (tsserver)**
  ```sh
  npm install -g typescript typescript-language-server
  ```
- **C/C++ (clangd)**
  - **Ubuntu:**
    ```sh
    sudo apt install clangd
    ```
  - **macOS:**
    ```sh
    brew install llvm
    ```
  - **Windows:**
    Download and install LLVM from the [official website](https://releases.llvm.org/).

*(Install additional language servers as needed.)*

---

## 6. Configure Neovim

Place your configuration in your `init.lua` file located in the appropriate directory:

### Linux/macOS
```sh
mkdir -p ~/.config/nvim
vim ~/.config/nvim/init.lua
```

### Windows
```sh
mkdir -p ~/AppData/Local/nvim
notepad ~/AppData/Local/nvim/init.lua
```

Your `init.lua` should include settings for:
- Basic options and lazy.nvim bootstrapping
- Plugin setup for colorscheme, file explorer, native LSP, Treesitter, ALE, Telescope (with the fzf-native extension), Copilot, and nvim-cmp
- Native LSP key mappings, Treesitter configuration, a built-in statusline, and a custom tabline

Refer to your configuration repository or documentation for the complete content.

---

## 7. Key Mappings Reference

Below is a table summarizing the key mappings defined in the configuration:

| **Context**           | **Shortcut**         | **Action**                                       | **Command/Function**                          |
|-----------------------|----------------------|--------------------------------------------------|-----------------------------------------------|
| **LSP (Normal Mode)** | `gd`                 | Go to definition                                 | `vim.lsp.buf.definition()`                    |
|                       | `gD`                 | Go to declaration                                | `vim.lsp.buf.declaration()`                   |
|                       | `gr`                 | List references                                  | `vim.lsp.buf.references()`                    |
|                       | `gi`                 | Go to implementation                             | `vim.lsp.buf.implementation()`                |
|                       | `K`                  | Display hover information                        | `vim.lsp.buf.hover()`                         |
|                       | `<leader>rn`         | Rename symbol                                    | `vim.lsp.buf.rename()`                        |
| **Completion Popup**  | `<C-Space>`          | Trigger completion menu                          | `cmp.mapping.complete()`                      |
|                       | `<C-e>`              | Close completion menu                            | `cmp.mapping.close()`                         |
|                       | `<C-y>`              | Confirm current selection                        | `cmp.mapping.confirm({ select = false })`      |
|                       | `<Down>`             | Select next completion item                      | `cmp.mapping.select_next_item()`              |
|                       | `<Up>`               | Select previous completion item                  | `cmp.mapping.select_prev_item()`              |
| **File Explorer**     | `<C-n>`              | Toggle neo-tree file explorer                    | `:Neotree toggle`                             |
| **Telescope**         | `<leader>ff`         | Find files using Telescope                       | `:Telescope find_files`                        |
|                       | `<leader>fg`         | Live grep with Telescope                         | `:Telescope live_grep`                         |
|                       | `<leader>fb`         | List open buffers via Telescope                  | `:Telescope buffers`                           |
|                       | `<leader>fh`         | Show help tags using Telescope                   | `:Telescope help_tags`                         |

*(Note: The `<leader>` key defaults to `\` unless you’ve customized it.)*

---

## 8. Start Neovim

Launch Neovim from your terminal:
```sh
nvim
```
