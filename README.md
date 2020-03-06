# Xavier Environment

This is an OSX development environment configuration. This README documents the complete process for setting up the development environment, and quickly getting up and running on any OSX machine.

As a general overview, this configuration will replace usage of the default terminal with ITerm2 and ZSH. It will utilize Oh-My-ZSH as the plugin manager for the terminal. This configuration will also configure a minimal, effective NeoVim environment with TMUX.

This entire development environment has theme synchronicity based on the OneDark theme.

![Color Reference][color_ref]

[color_ref]: (https://raw.githubusercontent.com/Rheisen/xavier-config/master/images/color_reference.png) "Color Reference"

### Step One: Downloads

- ITerm2 ([web link](https://iterm2.com/downloads.html))
- Homebrew ([web link](https://brew.sh/))
- Fira Code w/ NerdFont Patch ([web link](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode))
- VimPlug ([web link](https://github.com/junegunn/vim-plug))

### Step Two: Brew Installation

- `brew install node`
- `brew install neovim`
- `brew install git`

### Step Three: Environment Configuration

- Git clone this repository inside the root directory.
- Hide the repository (optional): `mv xavier-config .xavier-config`
- Symlink the ZSH configuration: `ln -s ~/.xavier-config/.zshrc ~/.zshrc`
- Symlink the Vim configuration: `ln -s ~/.xavier-config/.vimrc ~/.vimrc`
- Symlink the NeoVim configuration: `ln -s ~/.xavier-config/init.vim ~/.config/nvim/init.vim`
- Symlink the TMUX configuration: `ln -s ~/.xavier-config/.tmux.conf ~/.tmux.conf`

