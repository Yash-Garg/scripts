#!/bin/bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: APACHE-2.0-only
#

# Prints a formatted header; used for outlining
function echoText() {
    RED="\033[01;31m"
    RST="\033[0m"

    echo -e "${RED}"
# shellcheck disable=SC2034
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "==  ${1}  =="
# shellcheck disable=SC2034
    echo -e "====$( for i in $(seq ${#1}); do echo -e "=\c"; done )===="
    echo -e "${RST}"
}

echoText "Cloning Device Sources!"

git clone https://github.com/Yash-Garg/android_device_lge_hammerhead -b aosp-9.0 device/lge/hammerhead
git clone https://github.com/Yash-Garg/proprietary_vendor_lge -b aosp-9.0 vendor/lge
git clone https://github.com/Unlegacy-Android/android_kernel_lge_hammerhead -b stable kernel/lge/hammerhead

# Setup build env
# shellcheck disable=SC1091
. build/envsetup.sh

# Prepare device
lunch aosp_hammerhead-userdebug

# Custom user@hostname
export KBUILD_BUILD_USER="YashGarg"
export KBUILD_BUILD_HOST="RaspberryPI"

echoText "Script Executed Successfully!"
