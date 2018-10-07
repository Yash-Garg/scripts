#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

# Prints a formatted header; used for outlining
function echoText() {
    RED="\033[01;31m"
    RST="\033[0m"

    echo -e "${RED}"
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "==  ${1}  =="
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "${RST}"
}

# Creates a new line
function newLine() {
    echo -e ""
}

# Function for installing debian packages
function debian_pkgs() {
    echoText "Installing and updating packages for DEBIAN"
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install zsh
}

# Function for installing arch packages
function arch_pkgs() {
    echoText "Installing and updating packages for ARCH"
    sudo pacman -Syyu
    sudo pacman -S neofetch firefox filezilla telegram-desktop etcher git mariadb gnupg paper-icon-theme zsh
    yaourt -S hyper anydesk sublime-text-dev spotify flat-remix-git --noconfirm
}

# Function for importing my GPG keys
function gpgkeys() {
    echoText "Importing GPG Keys"
    git clone https://github.com/Yash-Garg/GPG_Keys.git ~/gpg_keys
    gpg --import ~/gpg_keys/ryzenbox_public.asc
    gpg --import ~/gpg_keys/ryzenbox_private.asc
}

# Function for configuring git
function git_cfg() {
    echoText "Configuring git"
    git config --global user.name "Yash Garg"
    git config --global user.email "ben10.yashgarg@gmail.com"
    git config --global signing.key 40C0AECA98D94CBF
}

# Function for installing zsh shell
function zsh_shell() {
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    chsh -s /bin/zsh
}

# Parameters
while [[ $# -gt 0 ]]
do
param="$1"

case $param in
     -a|--arch)
     ARCH="arch"
     ;;
     -d|--debian)
     DEBIAN="debian"
     ;;
     -h|--help)
     newLine; echo "Usage: bash distro-setup.sh -a or -d [For arch/debian]"; newLine
     exit
     ;;
esac
shift
done

# Print this if no parameters provided
if [[ "${ARCH}" != '1' ]]; then
     newLine; echo "Invalid input: Please provide a parameter! It is mandatory."; newLine

elif [[ "${DEBIAN}" != '1' ]]; then
     newLine; echo "Invalid input: Please provide a parameter! It is mandatory."; newLine
fi

# Define actions on parameters
if [[ "${ARCH}" == "arch" ]]; then
    arch_pkgs;
    gpgkeys;
    git_cfg;
    echo "Configured!"
    newLine; zsh_shell; newLine
    echoText "Script succeeded"

elif [[ "${DEBIAN}" == "debian" ]]; then
    debian_pkgs;
    gpgkeys;
    git_cfg;
    echo "Configured!"
    newLine; zsh_shell; newLine
    echoText "Script succeeded"
fi
