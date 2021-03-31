#!/bin/bash

# MESSAGE OUTPUT COLORS

green=$(tput setaf 34)
red=$(tput setaf 1)
yellow=$(tput setaf 3)
blue=$(tput setaf 39)
normal=$(tput sgr0)

# HELPER FUNCTIONS

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

dir_exists() {
    [ -d "$@" ] 2>&1
}

fmt_error() {
    echo "${red}Error: $@${normal}" >&2
}

abort() {
    printf "%s\n" "$1"
    exit 1
}

wait_for_user() {
    echo
    read -s -n 1 -p "${yellow}Press RETURN to continue or any other key to abort${normal}" c
    if ! [[ "$c" == "" ]]; then
        echo
        echo
        echo "Aborted."
        exit 1
    fi
}

# INSTALL SCRIPT START

OS="$(uname)"
if [[ "$OS" == "Linux" ]]; then
    abort "Unfortunately Xavier Config only supports macOS currently - please put in a PR if you can add Linux support!"
elif [[ "$OS" != "Darwin" ]]; then
    abort "Xavier Config is only supported on macOS."
fi

echo
echo "${green}Xavier Config Installer${normal}" 
echo
echo "This install script will check for and install Homebrew, in addition to the required brews for Xavier Config:"
echo "[1] Zsh [2] Coreutils [3] Neovim [4] Git [5] Tmux [6] Fzf [7] Ripgrep [8] Bat"
echo "After the required brews are installed, optional brews will be installed with (y/n) user prompts."
echo
echo "The install script will then check for and install Oh-My-Zsh, PowerLevel9K, VimPlug, and finally Xavier Config"
echo "After the install is complete, the Xavier Config directory will exist at ~/.xavier-config."
echo
echo "Any prior .zshrc .tmux.conf or init.vim files are backed up during the install process to a timestamped backup"
echo "folder within ~/.xavier-config."
echo
echo "The files ~/.zshrc ~/.tmux.conf and ~/.config/nvim/init.vim will be symlinked to files within ~/.xavier-config"
echo
echo "After the install process, please follow the manual steps listed on the Xavier Config Github Page."
wait_for_user

step=1
echo
echo
if ! command_exists brew; then
    echo "${yellow}$step: Homebrew not detected. Running the Homebrew install script...${normal}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if ! command_exists brew; then
    fmt_error "Homebrew not detected. Please check that Homebrew installed correctly."
    exit 1
else
    echo "${blue}$step: Homebrew detected.${normal}"
fi


# REQUIRED BREWS

((step++))
echo
echo "${blue}$step: Checking for required brews...${normal}"
for i in 1,Zsh,zsh 2,Coreutils,coreutils 3,Neovim,neovim 4,Git,git 5,Tmux,tmux 6,Fzf,fzf 7,Ripgrep,ripgrep 8,Bat,bat;
do IFS=",";
    set -- $i;
    if brew ls --versions $3 > /dev/null; then
        echo "$step.$1: $2 brew detected, skipping install."
    else
        echo "${yellow}$step.$1: $2 brew not detected, installing $3...${normal}"
        brew install $3
    fi
done

# OPTIONAL BREWS

((step++))
echo
echo "${blue}$step: Checking for optional brews...${normal}"
for i in 1,Gradle,gradle 2,"Spring Boot",pivotal/tap/springboot 3,Gnupg,gnupg 4,Gnupg2,gnupg2 5,"Git Flow",git-flow;
do IFS=",";
    set -- $i;
    if brew ls --versions $3 > /dev/null; then
        echo "$step.$1: $2 brew detected, skipping install."
    else
        while true; do
            read -p "${yellow}$step.$1: $2 brew not detected, would you like to install $3?${normal} (y/n): " opt

            if [ "$opt" == "y" ] || [ "$opt" == "Y" ]; then
                brew install $3
                break
            elif [ "$opt" == "n" ] || [ "$opt" == "N" ]; then
                echo "$step.$1: Skipping $2."
                break
            else
                echo "$step.$1: Invalid response: $opt"
            fi
        done
    fi
done


# OH-MY-ZSH INSTALL

((step++))
ohmyzsh_dir=~/.oh-my-zsh
echo
if ! dir_exists $ohmyzsh_dir; then
    echo "${yellow}$step: Oh-My-Zsh not detected. Running the Oh-My-Zsh install script...${normal}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! dir_exists $ohmyzsh_dir; then
    fmt_error "Oh-My-Zsh not detected. Please check that Oh-My-Zsh installed correctly."
    exit 1
else
    echo "${blue}$step: Oh-My-Zsh detected.${normal}"
fi

# POWERLEVEL9K INSTALL

command_exists git || {
    fmt_error "Git not detected. Please check that Git installed correctly."
    exit 1
}

((step++))
powerlevel9k_dir="$ohmyzsh_dir/custom/themes/powerlevel9k"
echo
if dir_exists $powerlevel9k_dir; then
    echo "${blue}$step: PowerLevel9K detected, skipping install.${normal}"
else
    echo "${yellow}$step: PowerLevel9K not detected, cloning PowerLevel9K...${normal}"
    git clone https://github.com/bhilburn/powerlevel9k.git $powerlevel9k_dir
fi

# VIM PLUG INSTALL

((step++))
vimplug_file=~/.local/share/nvim/site/autoload/plug.vim
echo
if [ -f "$vimplug_file" ]; then
    echo "${blue}$step: VimPlug for Neovim detected, skipping install.${normal}"
else
    echo "${yellow}$step: VimPlug for Neovim not detected, installing VimPlug...${normal}"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# ITERM2 & FIRA CODE FONT INSTALL

((step++))
echo
echo "${blue}$step: Checking for iTerm2 and Fira-Code-Font...${normal}"

if test -d "/Applications/iTerm.app" ; then
    echo "$step.1: iTerm2 app detected, skipping install."
elif brew ls --cask --versions iterm2 > /dev/null; then
    echo "$step.1: iTerm2 brew detected, skipping install."
else
    echo "${yellow}$step.1: iTerm2 not detected, installing iterm2...${normal}"
    brew install --cask iterm2
fi

# todo: checking for installation of font (non-brew) doesn't work
font_path="~/Library/Fonts/Fira Code Retina Nerd Font Complete.ttf"
if test -f "$font_path"; then 
    echo "$step.2: Fira Code font detected, skipping install."
elif brew ls --cask --versions font-fira-code > /dev/null; then
    echo "$step.2: Fira Code font brew detected, skipping install."
else
    echo "${yellow}$step.2: Fira Code font not detected, installing font-fira-code...${normal}"
    brew tap homebrew/cask-fonts
    brew install --cask font-fira-code
fi

# XAVIER CONFIG SETUP

((step++))
xconfig_dir=~/.xavier-config
xbackup_dir="$xconfig_dir/backup_$(date +%Y-%m-%d_%T)"
echo
echo "${blue}$step: Setting up Xavier Config...${normal}"
if dir_exists $xconfig_dir; then
    echo "$step.1: Xavier config detected, skipping clone."
else
    echo "${yellow}$step.1: Xavier config not detected, cloning xavier-config into $xconfig_dir${normal}"
    git clone https://github.com/Rheisen/xavier-config.git $xconfig_dir
fi

# Nvim init.vim symlink setup

command_exists realpath || {
    fmt_error "realpath not detected. Please check that CoreUtils installed correctly."
    exit 1
}

nvim_init_file=~/.config/nvim/init.vim
xconfig_nvim_init_file="$xconfig_dir/nvim/init.vim"
dir_exists ~/.config/nvim || {
    mkdir -p ~/.config/nvim
}
if [ -L "$nvim_init_file" ]; then
    if [ "$(realpath $nvim_init_file)" == "$xconfig_nvim_init_file" ]; then
        echo "$step.2: Neovim symlink to xavier-config init file already in place, skipping symlink."
    else
        rm $nvim_init_file
        ln -s $xconfig_nvim_init_file $nvim_init_file
        echo "${yellow}$step.2: Neovim symlink to init file replaced with symlink to xavier-config init file.${normal}"
    fi
elif [ -f "$nvim_init_file" ]; then
    dir_exists "$xbackup_dir" || {
        mkdir "$xbackup_dir"
    }
    cp $nvim_init_file "$xbackup_dir/init.vim"
    echo "${yellow}$step.2: Neovim init.vim file found, backup created at $xbackup_dir/init.vim${normal}"
    rm $nvim_init_file
    ln -s $xconfig_nvim_init_file $nvim_init_file
    echo "${yellow}$step.2: Neovim init.vim file replaced with symlink to xavier-config init file.${normal}"
else
    ln -s $xconfig_nvim_init_file $nvim_init_file
    echo "${yellow}$step.2: Neovim symlink to xavier-config init file created.${normal}"
fi

# Zsh .zshrc symlink setup

zshrc_file=~/.zshrc
xconfig_ex_zshrc_file="$xconfig_dir/zsh/.zshrc-example"
xconfig_zshrc_file="$xconfig_dir/zsh/.zshrc"
if ! [ -f "$xconfig_zshrc_file" ]; then
    echo "$step.3: Creating xavier-config .zshrc base file from .zshrc-example file."
    cp $xconfig_ex_zshrc_file $xconfig_zshrc_file
fi

if [ -L "$zshrc_file" ]; then
    if [ "$(realpath $zshrc_file)" == "$xconfig_zshrc_file" ]; then
        echo "$step.3: Zsh symlink to xavier-config zshrc file already in place, skipping symlink."
    else
        rm $zshrc_file
        ln -s $xconfig_zshrc_file $zshrc_file
        echo "${yellow}$step.3: Zsh symlink to zshrc file replaced with symlink to xavier-config zshrc file.${normal}"
    fi
elif [ -f "$zshrc_file" ]; then
    dir_exists "$xbackup_dir" || {
        mkdir "$xbackup_dir"
    }
    cp $zshrc_file "$xbackup_dir/.zshrc"
    echo "${yellow}$step.3: Zsh zshrc file found, backup created at $xbackup_dir/.zshrc${normal}"
    rm $zshrc_file
    ln -s $xconfig_zshrc_file $zshrc_file
    echo "${yellow}$step.3: Zsh symlink to xavier-config zshrc file created.${normal}"
else
    ln -s $xconfig_zshrc_file $zshrc_file
    echo "${yellow}$step.3: Zsh symlink to xavier-config zshrc file created.${normal}"
fi

# Tmux .tmux.conf symlink setup

tmux_conf_file=~/.tmux.conf
xconfig_tmux_conf_file="$xconfig_dir/zsh/.tmux.conf"
if [ -L "$tmux_conf_file" ]; then
    if [ "$(realpath $tmux_conf_file)" == "$xconfig_tmux_conf_file" ]; then
        echo "$step.4: Tmux symlink to xavier-config tmux.conf file already in place, skipping symlink."
    else
        rm $tmux_conf_file
        ln -s $xconfig_tmux_conf_file $tmux_conf_file
        echo "${yellow}$step.4: Tmux symlink to tmux.conf file replaced with symlink to xavier-config "
        echo "tmux.conf file.${normal}"
    fi
elif [ -f "$tmux_conf_file" ]; then
    dir_exists "$xbackup_dir" || {
        mkdir "$xbackup_dir"
    }
    cp $tmux_conf_file "$xbackup_dir/.tmux.conf"
    echo "${yellow}$step.4: Tmux zshrc file found, backup created at $xbackup_dir/.tmux.conf${normal}"
    rm $tmux_conf_file
    ln -s $xconfig_tmux_conf_file $tmux_conf_file
    echo "${yellow}$step.4: Tmux symlink to xavier-config tmux.conf file created.${normal}"
else
    ln -s $xconfig_tmux_conf_file $tmux_conf_file
    echo "${yellow}$step.4: Tmux symlink to xavier-config tmux.conf file created.${normal}"
fi

xiterm_assets_dir=~/documents/xavier-config/iterm
dir_exists $xiterm_assets_dir || {
    mkdir -p ~/documents/xavier-config
    cp -r "$xconfig_dir/iterm" "$xiterm_assets_dir"
}

echo
echo "${green}Xavier Config Installer Finished! Refer to the manual setup section to finish the setup.${normal}"
echo "Opening the xavier-config directory ($xconfig_dir)"
echo "Opening the xavier-config iterm assets directory($xiterm_assets_dir)"
open $xconfig_dir
open $xiterm_assets_dir

exit
