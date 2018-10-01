#!/usr/bin/env bash

# Copyright (C) Yash Garg <ben10.yashagarg@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only

# Prints a formatted header; used for outlining
function echoText() {
    RED="\033[01;31m"
    RST="\033[0m"

    echo -e ${RED}
    echo -e "====$( for i in `seq ${#1}`; do echo -e "=\c"; done )===="
    echo -e "==  ${1}  =="
    echo -e "====$( for i in `seq ${#1}`; do echo -e "=\c"; done )===="
    echo -e ${RST}
}

echoText "Setting up build environment"

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install openjdk-8-jdk git-core gnupg flex bison gperf lib32ncurses5-dev libx11-dev
sudo apt-get install build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386  x11proto-core-dev
sudo apt-get install lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip make bc schedtool repo imagemagick

echoText "Setup completed!"
