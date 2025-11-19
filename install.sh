#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

teach_em() {
    echo -e "${YELLOW}No argument provided, you need to either pass:${NC}"
    echo -e "${YELLOW}  - 'user' to install the project for non-owners of the repo that want my configs${NC}"
    echo -e "${YELLOW}      This option is for people that want to use my configs and be along for the ride${NC}"
    echo -e "${RED}  - 'owner' to install the project for owners of the repo${NC}"
    echo -e "${RED}      This option is for me, you can run it if you want but the dev-env script will yell at you during the update portion of the script${NC}"
    exit 1
}

if [ -z "$1" ]; then
    teach_em
fi

set_access() {
    if [ "$1" != "user" ] && [ "$1" != "owner" ]; then
        teach_em
    fi
    echo "Saving access perms: $1"
    echo "export PERMS_DEV_ENV=\"$1\"" >>$HOME/."$shell"rc
}

set_perms() {
    chmod +x scripts/*
}

detect_shell() {
    echo "Detecting shell..."
    if [ -n "$BASH_VERSINFO" ]; then
        shell="bash"
    elif [ -n "$ZSH_VERSION" ]; then
        shell="zsh"
    else
        echo "Unsupported shell. You need either bash or zsh for this."
        exit 1
    fi
    echo "Detected shell: $shell"
}

update_existing_packages() {
    if command -v apt-get; then
        sudo apt-get update
        sudo apt-get upgrade
    elif command -v pacman; then
        sudo pacman -Syu
    else
        echo "No supported package manager found. It is recommended to update your packages before installing new ones."
        exit 1
    fi
}

install_package() {
    PACKAGE_NAME=$1
    if command -v apt-get; then
        sudo apt-get install -y "$PACKAGE_NAME" && echo -e "${GREEN}Installed $PACKAGE_NAME.${NC}" || echo -e "${RED}Error installing $PACKAGE_NAME!${NC}"
    elif command -v pacman; then
        yes | sudo pacman -S "$PACKAGE_NAME" && echo -e "${GREEN}Installed $PACKAGE_NAME.${NC}" || echo -e "${RED}Error installing $PACKAGE_NAME!${NC}"
    else
        echo "No supported package manager found. Install $PACKAGE_NAME manually."
        exit 1
    fi
}

install_packages() {
    update_existing_packages
    PACKAGE_FILE=./package_list.txt
    if [ ! -f $PACKAGE_FILE ]; then
        echo "Package list file not found."
        exit 1
    else
        for package in $(cat $PACKAGE_FILE); do
            echo "Installing $package..."
            install_package $package
        done
    fi
}

ensure_tools_installed() {
    if ! which xnote; then
        install_xnote
    fi
}

install_xnote() {
    cd /tmp
    git clone https://github.com/wellatleastitried/xnote.git
    cd xnote
    sudo install -m 755 ./xnote /usr/local/bin/xnote || echo "Installing xnote failed!"
    cd $DEV_ENV_PATH
    rm -rf /tmp/xnote
}

ensure_repo_staged() {
    if ! grep -q "PATH_DEV_ENV" $HOME/."$shell"rc; then
        DEV_ENV_PATH="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
        echo "export PATH_DEV_ENV=\"$DEV_ENV_PATH\"" >>$HOME/."$shell"rc
        echo "export PATH=\$PATH:$DEV_ENV_PATH" >>$HOME/."$shell"rc
    fi
}

detect_shell
set_access $1
set_perms
ensure_repo_staged
install_packages
ensure_tools_installed

echo -e "${RED}NOTICE${NC}"
echo "When modifying your configs, do it in this repos config folder using 'dev-env edit'. It will make deploying/saving the configuration simpler."
