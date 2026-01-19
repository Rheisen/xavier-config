
# Xavier Config

This is an OSX development environment configuration. This README documents the complete process for setting up the
development environment, and quickly getting up and running on any OSX machine.

As a general overview, this configuration will replace usage of the default terminal with ITerm2 and Zsh.
It uses Zinit as the plugin manager for the terminal. This configuration also provides a robust Neovim and Tmux setup.

This development environment has theme synchronicity based on the Tiede theme, and takes a minimalist stylistic
approach with powerful, well-integrated features. ([Teide Theme](https://github.com/serhez/teide.nvim))

With the usage of the install script, it can be fully configured in less than 5 minutes!

![Color Reference](https://raw.githubusercontent.com/Rheisen/xavier-config/images/teide_dark_color_reference.png)

Colors: `#1D2228` (background), `#F97791` (red), `#38FFA5` (green), `#FFE77A` (yellow), `#5CCEFF` (blue),
`#A592FF` (purple), `#0AE7FF` (cyan), `#E7EAEE` (foreground)

## Quick Install

1. Run the installer script: `/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Rheisen/xavier-config/main/install.sh)"`
    - This will install ITerm2 ([web link](https://iterm2.com/downloads.html))
    and Fira Code Nerd Font ([web link](https://www.nerdfonts.com/font-downloads))
    - This will install Xcode Command Line Tools
    - This will install Homebrew and some dependencies via brew
    - This will install Rust and some dependencies via cargo
    - This will install Node Version Manager and the latest LTS Node version via nvm
    - This will make backups of any existing zshrc / tmux / neovim configuration and setup symlinks to Xavier Config
    - This will create a dynamic ITerm2 profile with the teide dark theme as the default profile
2. Switch to ITerm2 or quit and reopen ITerm2 if you used it for the install (Zinit and zsh plugins will auto-install)
3. Plugins and Language Servers for Neovim will auto-install with Lazy when opening Neovim (`nvim`)
4. All done! Check out the next section for usage tips

## Usage

TBD

#### Additional Recommended Downloads:

- Ruby Version Manager (RVM) ([web link](https://rvm.io/))

## Manual Install

### Step One: Downloads

- ITerm2 ([web link](https://iterm2.com/downloads.html))
- Homebrew ([web link](https://brew.sh/))
- Stop here!! Complete Step Two
- Zinit ([web link](https://github.com/zdharma-continuum/zinit))
- Done

### Step Two: Brew Installations

Install or upgrade the following with Homebrew:

- `brew install zsh`
- `brew install neovim`
- `brew install git`
- `brew install tmux`
- `brew install fzf`
- `brew install ripgrep`
- `brew install fd`
- `brew install zoxide`
- Done

#### Recommended Brews
- `brew install gradle`
- `brew tap pivotal/tap`
- `brew install springboot`
- `brew install gnupg gnupg2`
- `brew install git-flow`

### Step Three: Clone this Repository

- Configure git if git is not already configured.
- Git clone this repository inside the root directory.
- Hide the repository (optional, recommended): `mv xavier-config .xavier-config`
- Open the repository with finder: `open ~/.xavier-config`
- Done

### Step Four: ITerm2 Setup

- Open ITerm2 (if you didn't use it in the previous step)
- Ensure Zsh is the default shell: `sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)`
- Copy the "iterm" folder somewhere easily findable: `cp ~/.xavier-config/iterm ~/documents/iterm`
- Open the ITerm2 Preferences Menu (ITerm2 > Preferences)
- Select Profiles, Select Colors, Select "Import" from Color Presets in bottom right corner
- Import `xavier-config.itermcolors` from within documents/iterm
- Recommended: No cursor guide, 0 Minimal Contrast, 0 Cursor Boost
- Select Text (still under Profiles), and change Font to FiraCode Nerd Font (Retina or Regular recommended)
- Done

### Step Five: Environment Configuration

#### Neovim (outdated instructions)
- Remove (`rm ~/.config/nvim/init.vim`) or create the nvim directory (`mkdir ~/.config; mkdir ~/.config/nvim`)
- Symlink the xavier-config NeoVim configuration: `ln -s ~/.xavier-config/nvim/init.vim ~/.config/nvim/init.vim`
- Open the nvim init file `nvim ~/.xavier-config/init.vim` and run `:PlugInstall`
- Follow the comments in the init.vim file for installing CoC language support as desired.
#### ZSH
- Copy the .zshrc-example file as the base for your new .zshrc: `cp ~/.xavier-config/zsh/.zshrc-example ~/.xavier-config/zsh/.zshrc`
- Open the zshrc file: `nvim ~/.xavier-config/zsh/.zshrc` and change the ZSH export as needed
- Add any additonal scripts from previous configuration files to this zshrc
- Remove the current ZSH configuration: `rm ~/.zshrc`
- Symlink the xavier-config ZSH configuration: `ln -s ~/.xavier-config/zsh/.zshrc ~/.zshrc`
#### TMUX
- Symlink the Tmux configuration: `ln -s ~/.xavier-config/.tmux.conf ~/.tmux.conf`
- Done
