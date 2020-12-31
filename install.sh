#!/bin/bash

green=$(tput setaf 34)
red=$(tput setaf 1)
yellow=$(tput setaf 3)
blue=$(tput setaf 39)
normal=$(tput sgr0)

CommandExists() {
	command -v "$@" >/dev/null 2>&1
}

DirExists() {
    [ -d "$@" ] 2>&1
}

FmtError() {
  echo "${red}Error: $@${normal}" >&2
}

printf "\n${green}----- Xavier Config Installer -----\n\n${normal}" 

if ! CommandExists brew; then
    printf "${yellow}1: Homebrew not detected, installing Homebrew...\n${normal}"
    -c curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
else
    printf "${blue}1: Homebrew detected, skipping install.\n${normal}"
fi

printf "\n${blue}2: Checking for required brews...\n${normal}"

# REQUIRED BREWS

for i in 1,Zsh,zsh 2,Neovim,neovim 3,Git,git 4,Tmux,tmux 5,Fzf,fzf 6,Ripgrep,ripgrep 7,Bat,bat; do IFS=",";
    set -- $i;
    if brew ls --versions $3 > /dev/null; then
        printf "2.$1: $2 brew detected, skipping install.\n"
    else
        printf "${yellow}2.$1: $2 brew not detected, installing $3...\n${normal}"
        brew install $3
    fi
done

# OPTIONAL BREWS

printf "\n${blue}3: Checking for optional brews...\n${normal}"

for i in 1,Gradle,gradle 2,"Spring Boot",pivotal/tap/springboot 3,Gnupg,gnupg 4,Gnupg2,gnupg2 5,"Git Flow",git-flow;
do IFS=",";
    set -- $i;
    if brew ls --versions $3 > /dev/null; then
        printf "3.$1: $2 brew detected, skipping install.\n"
    else
        while true; do
            read -p "${yellow}3.$1: $2 brew not detected, would you like to install $3?${normal} (y/n): " optInstall

            if [ "$optInstall" == "y" ] || [ "$optInstall" == "Y" ]; then
                brew install $3
                break
            elif [ "$optInstall" == "n" ] || [ "$optInstall" == "N" ]; then
                printf "3.$1: Skipping $2.\n"
                break
            else
                printf "3.$1: Invalid response: $optInstall\n"
            fi
        done
    fi
done

# OH-MY-ZSH INSTALL

ohmyzshDir=~/.oh-my-zsh
if [ -d "$ohmyzshDir" ]; then
    printf "\n${blue}4: Oh-My-Zsh detected, skipping install.\n${normal}"
else
    printf "\n${yellow}4: Oh-My-Zsh not detected, installing Oh-My-Zsh...\n${normal}"
    -c curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
fi

# POWERLEVEL9K INSTALL

CommandExists git || {
    FmtError "Git is not installed, exiting early."
    exit 1
}

powerlevel9kDir="$ohmyzshDir/custom/themes/powerlevel9k"
if [ -d "$powerlevel9kDir" ]; then
    printf "\n${blue}5: PowerLevel9K detected, skipping install.\n${normal}"
else
    printf "\n${yellow}5: PowerLevel9K not detected, cloning PowerLevel9K...\n${normal}"
    git clone https://github.com/bhilburn/powerlevel9k.git $powerlevel9kDir
fi

# VIM PLUG INSTALL

vimplugFile=~/.local/share/nvim/site/autoload/plug.vim
if [ -f "$vimplugFile" ]; then
    printf "\n${blue}6: VimPlug for Neovim detected, skipping install.\n${normal}"
else
    printf "\n${yellow}6: VimPlug for Neovim not detected, installing VimPlug...\n${normal}"
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

# XAVIER CONFIG SETUP

printf "\n${blue}7: Setting up Xavier Config...\n${normal}"
configDir=~/.xavier-config
backupDir="$configDir/backup_$(date +%Y-%m-%d_%T)"

if [ -d "$configDir" ]; then
    printf "7.1: Xavier config detected, skipping clone.\n"
else
    printf "${yellow}7.1: Xavier config not detected, cloning xavier-config into $configDir\n${normal}"
    git clone https://github.com/Rheisen/xavier-config.git $configDir
fi

# Nvim init.vim symlink setup

nvimInitFile=~/.config/nvim/init.vim
configInitFile="$configDir/nvim/init.vim"
DirExists ~/.config/nvim || {
    mkdir -p ~/.config/nvim
}
if [ -L "$nvimInitFile" ]; then
    if [ "$(realpath $nvimInitFile)" == "$configInitFile" ]; then
        printf "7.2: Neovim symlink to xavier-config init file already in place, skipping symlink.\n"
    else
        rm $nvimInitFile
        ln -s $configInitFile $nvimInitFile
        printf "${yellow}7.2: Neovim symlink to init file replaced with symlink to xavier config init file.\n${normal}"
    fi
elif [ -f "$nvimInitFile" ]; then
    DirExists "$backupDir" || {
        mkdir "$backupDir"
    }
    cp $nvimInitFile "$backupDir/init.vim"
    printf "${yellow}7.2: Neovim init.vim file found, backup created at $backupDir/init.vim\n${normal}"
    rm $nvimInitFile
    ln -s $configInitFile $nvimInitFile
    printf "${yellow}7.2: Neovim init.vim file replaced with symlink to xavier config init file.\n${normal}"
else
    ln -s $configInitFile $nvimInitFile
    printf "${yellow}7.2: Neovim symlink to xavier-config init file created.\n${normal}"
fi

# Zsh .zshrc symlink setup

zshFile=~/.zshrc
configExampleZshFile="$configDir/zsh/.zshrc-example"
configZshFile="$configDir/zsh/.zshrc"
if ! [ -f "$configZshFile" ]; then
    printf "7.3: Creating xavier-config .zshrc base file from .zshrc-example file."
    cp $configExampleZshFile $configZshFile
fi

if [ -L "$zshFile" ]; then
    if [ "$(realpath $zshFile)" == "$configZshFile" ]; then
        printf "7.3: Zsh symlink to xavier-config zshrc file already in place, skipping symlink.\n"
    else
        rm $zshFile
        ln -s $configZshFile $zshFile
        printf "${yellow}7.3: Zsh symlink to zshrc file replaced with symlink to xavier config zshrc file.\n${normal}"
    fi
elif [ -f "$zshFile" ]; then
    DirExists "$backupDir" || {
        mkdir "$backupDir"
    }
    cp $zshFile "$backupDir/.zshrc"
    printf "${yellow}7.3: Zsh zshrc file found, backup created at $backupDir/.zshrc\n${normal}"
    rm $zshFile
    ln -s $configZshFile $zshFile
    printf "${yellow}7.3: Zsh symlink to xavier-config zshrc file created.\n${normal}"
else
    ln -s $configZshFile $zshFile
    printf "${yellow}7.3: Zsh symlink to xavier-config zshrc file created.\n${normal}"
fi

# Tmux .tmux.conf symlink setup

tmuxConfFile=~/.tmux.conf
configTmuxConfFile="$configDir/zsh/.tmux.conf"
if [ -L "$tmuxConfFile" ]; then
    if [ "$(realpath $tmuxConfFile)" == "$configTmuxConfFile" ]; then
        printf "7.4: Tmux symlink to xavier-config tmux.conf file already in place, skipping symlink.\n"
    else
        rm $tmuxConfFile
        ln -s $configTmuxConfFile $tmuxConfFile
        printf "${yellow}7.4: Tmux symlink to tmux.conf file replaced with symlink to xavier-config "
        printf "tmux.conf file.\n${normal}"
    fi
elif [ -f "$tmuxConfFile" ]; then
    DirExists "$backupDir" || {
        mkdir "$backupDir"
    }
    cp $tmuxConfFile "$backupDir/.tmux.conf"
    printf "${yellow}7.4: Tmux zshrc file found, backup created at $backupDir/.tmux.conf\n${normal}"
    rm $tmuxConfFile
    ln -s $configTmuxConfFile $tmuxConfFile
    printf "${yellow}7.4: Tmux symlink to xavier-config tmux.conf file created.\n${normal}"
else
    ln -s $configTmuxConfFile $tmuxConfFile
    printf "${yellow}7.4: Tmux symlink to xavier-config tmux.conf file created.\n${normal}"
fi

itermAssetsDir=~/documents/xavier-config/iterm
DirExists $itermAssetsDir || {
    mkdir -p ~/documents/xavier-config
    cp -r "$configDir/iterm" "$itermAssetsDir"
}

printf "\n${green}Xavier Config Installer Finished! Refer to the manual setup section to finish the setup.\n${normal}"
printf "Opening the xavier-config directory ($configDir)\n"
printf "Opening the xavier-config iterm assets directory($itermAssetsDir)\n"
open $configDir
open $itermAssetsDir

exit
