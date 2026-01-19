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
    [ -d "$*" ] 2>&1
}

fmt_error() {
    echo "${red}Error: $*${normal}" >&2
}

abort() {
    printf "%s\n" "$1"
    exit 1
}

wait_for_user() {
    echo
    read -r -s -n 1 -p "${yellow}Press RETURN to continue or any other key to abort${normal}" c
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
echo "An initial check is made for xcode command line tools, and if it isn't found it starts the install process."
echo "If xcode command line tools needs to be installed, this script needs to be run again."
echo
echo "This install script will then check for and install Homebrew along with the required brews for Xavier Config:"
echo "[1] Zsh [2] Coreutils [3] Neovim [4] Git [5] Tmux [6] Fzf [7] Ripgrep [8] Fd [9] Zoxide"
echo
echo "After the required brews, Rust is installed and an additional dependency is installed via Cargo (Tree-sitter)."
echo
echo "Once these required dependencies are installed, optional brews will be installed with (y/n) user prompts."
echo
echo "With all required and optional dependencies installed, the install script will clone the Xavier Config repo."
echo "The Xavier Config directory will exist at ~/.xavier-config."
echo
echo "Any prior .zshrc .tmux.conf or init.vim files are backed up during the install process to a timestamped backup"
echo "folder within ~/.xavier-config."
echo
echo "The files ~/.zshrc ~/.tmux.conf and the directory ~/.config/nvim will be symlinked to files within"
echo "$HOME/.xavier-config"
echo
echo "After the install process, please follow the manual steps listed on the Xavier Config Github Page."
echo "https://github.com/rheisen/xavier-config"
echo "The only manual steps are setting up the ITerm profile with the theme colors."
echo
echo "Zinit will automatically install itself and zsh plugins when the terminal next opens."
echo "Lazy and Mason will automatically install Neovim plugins and language servers when nvim next opens."
wait_for_user

# XCODE COMMAND LINE TOOLS (C COMPILER)

step=1
echo
if command_exists cc; then
    echo "${blue}$step: C compiler detected.${normal}"
else
    echo "${yellow}$step: C compiler not detected. Installing Xcode Command Line Tools...${normal}"
    xcode-select --install
    echo "${yellow}$step: Please complete the Xcode Command Line Tools installation prompt, then re-run this script.${normal}"
    exit 0
fi

# HOMEBREW

((step++))
echo
echo
if ! command_exists brew; then
    echo "${yellow}$step: Homebrew not detected. Running the Homebrew install script...${normal}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

requiredBrews=(
    "Zsh:zsh"
    "Coreutils:coreutils"
    "Neovim:neovim"
    "Git:git"
    "Tmux:tmux"
    "Fzf:fzf"
    "Ripgrep:ripgrep"
    "Fd:fd"
    "Zoxide:zoxide"
)

for i in "${!requiredBrews[@]}"; do
    index=$((i+1))
    name="${requiredBrews[$i]%%:*}"
    formula="${requiredBrews[$i]##*:}"
    if brew ls --versions "$formula" > /dev/null; then
        echo "$step.$index: $name brew detected, skipping install."
    else
        echo "${yellow}$step.$index: $name brew not detected, installing $formula...${normal}"
        brew install "$formula"
    fi
done

# RUST/CARGO/RUSTUP INSTALL

((step++))
echo
if command_exists rustup; then
    echo "${blue}$step.1: Rustup detected.${normal}"
else
    echo "${yellow}$step.1: Rustup not detected. Running the Rustup install script...${normal}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi
if ! command_exists rustup; then
    fmt_error "Rustup not detected. Please check that Rustup installed correctly."
    exit 1
fi

# TREE-SITTER-CLI INSTALL

echo
if command_exists tree-sitter; then
    echo "${blue}$step.2: tree-sitter-cli detected.${normal}"
else
    echo "${yellow}$step.2: tree-sitter-cli not detected. Installing via cargo...${normal}"
    cargo install --locked tree-sitter-cli
fi

# NVM AND NODE INSTALL

((step++))
echo
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "${blue}$step.1: nvm detected.${normal}"
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
else
    echo "${yellow}$step.1: nvm not detected. Installing nvm...${normal}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
fi

if command_exists node; then
    echo "${blue}$step.2: Node detected.${normal}"
else
    echo "${yellow}$step.2: Node not detected. Installing latest LTS via nvm...${normal}"
    nvm install --lts
fi

# OPTIONAL BREWS

((step++))
echo
echo "${blue}$step: Checking for optional brews...${normal}"

optionalBrews=(
    "ShellCheck:shellcheck"
    "JQ:jq"
    "Git Flow:git-flow"
    "Kubernetes CLI (kubectl):kubectl"
    "Helm:helm"
    "DigitalOcean CLI (doctl):doctl"
    "Gradle:gradle"
    "Gnupg:gnupg"
    "Gnupg 2:gnupg2"
)

for i in "${!optionalBrews[@]}"; do
    index=$((i+1))
    name="${optionalBrews[$i]%%:*}"
    formula="${optionalBrews[$i]##*:}"

    if brew ls --versions "$formula" > /dev/null; then
        echo "$step.$index: $name brew detected, skipping install."
    else
        while true; do
            read -r -p "${yellow}$step.$index: $name brew not detected, would you like to install $formula?${normal} (y/n): " opt

            if [ "$opt" == "y" ] || [ "$opt" == "Y" ]; then
                brew install "$formula"
                break
            elif [ "$opt" == "n" ] || [ "$opt" == "N" ]; then
                echo "$step.$index: Skipping $name."
                break
            else
                echo "$step.$index: Invalid response: $opt"
            fi
        done
    fi
done

# OPTIONAL TAPS

((step++))
echo
echo "${blue}$step: Checking for optional taps...${normal}"
optionalTaps=(
    "1Password CLI (op):1password/tap/1password-cli:op"
    "Spring Boot:spring-io/tap/spring-boot:spring"
)

for i in "${!optionalTaps[@]}"; do
    index=$((i+1))
    entry="${optionalTaps[$i]}"
    name="${entry%%:*}"
    remainder="${entry#*:}"
    formula="${remainder%%:*}"
    cmd="${remainder##*:}"

    if [ -x "$(command -v "$cmd")" ]; then
        echo "$step.$index: $name detected, skipping install."
    else
        while true; do
            read -r -p "${yellow}$step.$index: $name not detected, would you like to install $formula?${normal} (y/n): " opt

            if [ "$opt" == "y" ] || [ "$opt" == "Y" ]; then
                brew install "$formula"
                break
            elif [ "$opt" == "n" ] || [ "$opt" == "N" ]; then
                echo "$step.$index: Skipping $name."
                break
            else
                echo "$step.$index: Invalid response: $opt"
            fi
        done
    fi
done

# TMUX PLUGIN MANAGER INSTALL

((step++))
tpm_dir=~/.tmux/plugins/tpm
if ! dir_exists "$tpm_dir"; then
    echo "${yellow}$step: tmux plugin manager repo not detected, cloning...${normal}"
    git clone "https://github.com/tmux-plugins/tpm" "$tpm_dir" || exit 1
else
    echo "${blue}$step: tmux plugin manager repo found, skipping install.${normal}"
fi

# ITERM2 INSTALL

((step++))
echo
echo "${blue}$step: Checking for iTerm2...${normal}"

if test -d "/Applications/iTerm.app" ; then
    echo "$step.1: iTerm2 app detected, skipping install."
elif brew ls --cask --versions iterm2 > /dev/null; then
    echo "$step.1: iTerm2 brew detected, skipping install."
else
    echo "${yellow}$step.1: iTerm2 not detected, installing iterm2...${normal}"
    brew install --cask iterm2
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
    git clone https://github.com/Rheisen/xavier-config.git $xconfig_dir || exit 1
fi

# Nvim config directory symlink setup

command_exists realpath || {
    fmt_error "realpath not detected. Please check that CoreUtils installed correctly."
    exit 1
}

nvim_config_dir=~/.config/nvim
xconfig_nvim_dir="$xconfig_dir/nvim-xavi"
dir_exists ~/.config || {
    mkdir -p ~/.config
}
if [ -L "$nvim_config_dir" ]; then
    if [ "$(realpath "$nvim_config_dir")" == "$xconfig_nvim_dir" ]; then
        echo "$step.2: Neovim config symlink to xavier-config nvim-xavi already in place, skipping."
    else
        rm "$nvim_config_dir"
        ln -s "$xconfig_nvim_dir" "$nvim_config_dir"
        echo "${yellow}$step.2: Neovim config symlink replaced with symlink to xavier-config nvim-xavi.${normal}"
    fi
elif [ -d "$nvim_config_dir" ]; then
    dir_exists "$xbackup_dir" || {
        mkdir "$xbackup_dir"
    }
    mv "$nvim_config_dir" "$xbackup_dir/nvim"
    echo "${yellow}$step.2: Neovim config directory found, backup created at $xbackup_dir/nvim${normal}"
    ln -s "$xconfig_nvim_dir" "$nvim_config_dir"
    echo "${yellow}$step.2: Neovim config symlink to xavier-config nvim-xavi created.${normal}"
else
    ln -s "$xconfig_nvim_dir" "$nvim_config_dir"
    echo "${yellow}$step.2: Neovim config symlink to xavier-config nvim-xavi created.${normal}"
fi

# Zsh .zshrc symlink setup

zshrc_file=~/.zshrc
xconfig_ex_zshrc_file="$xconfig_dir/zsh/.zshrc-example"
xconfig_zshrc_file="$xconfig_dir/zsh/.zshrc"
if ! [ -f "$xconfig_zshrc_file" ]; then
    echo "$step.3: Creating xavier-config .zshrc base file from .zshrc-example file."
    sed "s/YOURUSERNAME/$USER/" $xconfig_ex_zshrc_file > $xconfig_zshrc_file
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
    echo "${yellow}$step.4: Tmux conf file found, backup created at $xbackup_dir/.tmux.conf${normal}"
    rm $tmux_conf_file
    ln -s $xconfig_tmux_conf_file $tmux_conf_file
    echo "${yellow}$step.4: Tmux symlink to xavier-config tmux.conf file created.${normal}"
else
    ln -s $xconfig_tmux_conf_file $tmux_conf_file
    echo "${yellow}$step.4: Tmux symlink to xavier-config tmux.conf file created.${normal}"
fi

# Fira Code Nerd Font installation

((step++))
echo "${blue}$step: Checking for Fira Code Nerd Font...${normal}"
if ls ~/Library/Fonts/FiraCodeNF*.ttf 1> /dev/null 2>&1; then
    echo "$step.1: Fira Code Nerd Font detected, skipping install."
else
    echo "${yellow}$step.1: Fira Code Nerd Font not detected, downloading and installing...${normal}"
    fira_code_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip"
    fira_code_tmp="/tmp/FiraCode.zip"
    fira_code_extract="/tmp/FiraCode"

    curl -L -o "$fira_code_tmp" "$fira_code_url"
    mkdir -p "$fira_code_extract"
    unzip -o "$fira_code_tmp" -d "$fira_code_extract"
    cp "$fira_code_extract"/*.ttf ~/Library/Fonts/

    # Cleanup
    rm -f "$fira_code_tmp"
    rm -rf "$fira_code_extract"
    echo "${yellow}$step.1: Fira Code Nerd Font installed.${normal}"
fi

# iTerm2 Dynamic Profile setup

iterm_dynamic_profiles_dir=~/Library/Application\ Support/iTerm2/DynamicProfiles
xconfig_iterm_profile="$xconfig_dir/iterm/xavi-config-teide-dark.json"
xavi_profile_guid="AC1B5929-3782-4BE7-866F-2E4D857BACF3"

((step++))
mkdir -p "$iterm_dynamic_profiles_dir"
if [ -L "$iterm_dynamic_profiles_dir/xavi-config-teide-dark.json" ]; then
    echo "$step: iTerm2 Xavi profile symlink already in place, skipping."
else
    ln -sf "$xconfig_iterm_profile" "$iterm_dynamic_profiles_dir/xavi-config-teide-dark.json"
    echo "${yellow}$step: iTerm2 Xavi profile symlink created.${normal}"
fi

# Set Xavi profile as default
defaults write com.googlecode.iterm2 "Default Bookmark Guid" "$xavi_profile_guid"
echo "${yellow}$step: iTerm2 Xavi profile set as default.${normal}"

xiterm_assets_dir=~/documents/xavier-config/iterm
dir_exists $xiterm_assets_dir || {
    mkdir -p ~/documents/xavier-config
    cp -r "$xconfig_dir/iterm" "$xiterm_assets_dir"
}

echo
echo "${green}Xavier Config Installer Finished! Refer to the manual setup section to finish the setup.${normal}"
echo "Opening the xavier-config directory ($xconfig_dir)"
echo "Opening the xavier-config iterm assets directory ($xiterm_assets_dir)"
open $xconfig_dir
open $xiterm_assets_dir

exit
