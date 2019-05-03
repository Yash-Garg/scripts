#!/usr/bin/env bash
#
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

# Colors for script
GRN="\033[01;32m"
RED="\033[01;31m"
RST="\033[0m"
YLW="\033[01;33m"

# Alias for echo to handle escape codes like colors
function echo() {
    command echo -e "$@"
}

# Prints an error in bold red
function die() {
    echo "${RED}${1}${RST}"
    [[ ${2} = "-h" ]] && ${0} -h
    echo
    exit 1
}

# Prints a statement in bold green
function success() {
    echo "${GRN}${1}${RST}"
    [[ -z ${2} ]] && echo
}

# Prints a statement in bold yellow
function prnt_ylw() {
    echo "${YLW}${1}${RST}"
    [[ -z ${2} ]] && echo
}

# Prints a formatted header; used for outlining
function echoText() {

    echo -e "${RED}"
    #shellcheck disable=SC2034
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "==  ${1}  =="
    #shellcheck disable=SC2034
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "${RST}"
}

# Creates a new line
function newLine() {
    echo -e ""
}

# Function for installing debian packages
function debian_pkgs() {
    newLine; success "Installing and updating packages for DEBIAN"
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get install -y zsh npm mariadb-server firefox git tilix uget aria2 nodejs \
                            lolcat cowsay apache2 golang python3 neovim ranger gcc shellcheck \
                            mosh curl android-tools-adb autoconf automake
}

# Function for installing arch packages
function arch_pkgs() {
    newLine; success "Installing and updating packages"
    sudo pacman -Syu
    yes | sudo pacman -S neofetch firefox filezilla telegram-desktop etcher git mariadb \
                         gnupg paper-icon-theme zsh npm tilix uget lolcat cowsay python3 \
                         golang nodejs gcc nano
    yaourt -S hyper anydesk sublime-text-dev spotify flat-remix-git --noconfirm
}

# Function for installing yaourt (aur helper)
function install_yaourt() {
    echoText "Installing yaourt (AUR Helper)"
    sudo pacman -S --needed base-devel git wget yajl
    git clone https://aur.archlinux.org/package-query.git
    # shellcheck disable=SC2164
    cd package-query/
    makepkg -si && cd ..
    git clone https://aur.archlinux.org/yaourt.git
    # shellcheck disable=SC2164
    cd yaourt/
    makepkg -si && cd ..
    sudo rm -dR yaourt/ package-query/
}

# Function for importing my GPG keys
function gpgkeys() {
    echoText "Importing GPG Keys"
    git clone https://github.com/Yash-Garg/GPG_Keys.git ~/gpg_keys
    gpg --import ~/gpg_keys/ryzenbox_public.asc
    gpg --import ~/gpg_keys/ryzenbox_private.asc
    echoText "Import Done"
    sudo rm -dR ~/gpg_keys
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

# Function for adding functions
function setup_functions() {
    #shellcheck disable=SC2164
    cd ~/
    wget https://raw.githubusercontent.com/Yash-Garg/scripts/master/personal-setup/functions.sh
    chmod +x functions.sh
    #shellcheck disable=SC1090
    source ~/functions.sh
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
     newLine; prnt_ylw "Usage: bash distro-setup.sh -a or -d [For arch/debian]";
     exit
     ;;

     *) newLine; die "Invalid parameter specified! Use --help/-h for more info" ;;

esac
shift
done

# Define actions on parameters
if [[ "${ARCH}" == "arch" ]]; then
    install_yaourt;
    arch_pkgs;
    gpgkeys;
    git_cfg;
    prnt_ylw "Configured!"
    newLine; zsh_shell; newLine
    setup_functions;
    success "Script succeeded"

elif [[ "${DEBIAN}" == "debian" ]]; then
    debian_pkgs;
    gpgkeys;
    git_cfg;
    prnt_ylw "Configured!"
    newLine; zsh_shell; newLine
    setup_functions;
    success "Script succeeded"
fi
