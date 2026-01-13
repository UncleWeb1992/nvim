# My Neovim Configuration 🚀

Modern Neovim setup with LSP, autocompletion, fuzzy finder, file tree and more. Optimized for Go, TypeScript/JavaScript, and web development.

## Features ✨

- **🎨 Modern UI**: Clean interface with icons and smooth animations
- **⚡ Fast**: Written in Lua, optimized for performance
- **🧩 Plugin Manager**: Lazy.nvim for efficient plugin loading
- **🤖 Smart Completion**: nvim-cmp with LSP support
- **🔍 Fuzzy Finder**: Telescope for file navigation
- **📁 File Tree**: Neo-tree with git status
- **💻 LSP Support**: gopls, tsserver, lua_ls, and more
- **🎯 Syntax Highlighting**: Treesitter with advanced features
- **📝 Auto Formatting**: Built-in LSP formatting + conform.nvim
- **⌨️ VS Code Keybinds**: Familiar keyboard shortcuts

## Quick Install 🚀

### 1. Prerequisites

```bash
# Neovim 0.11.5 or higher
nvim --version

# Required system tools
sudo dnf install git curl gcc make  # Fedora
# or
sudo apt install git curl gcc make  # Ubuntu/Debian

# Recommended tools for better experience
sudo dnf install ripgrep fd-find python3 nodejs npm golang  # Fedora

# Backup old config (if exists)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup

# Clone this repo
git clone https://github.com/UncleWeb1992/nvim.git ~/.config/nvim

unzip stylua-linux-x86_64.zip
chmod +x stylua
sudo mv stylua /usr/local/bin/

# Start Neovim (plugins will auto-install)
nvim
