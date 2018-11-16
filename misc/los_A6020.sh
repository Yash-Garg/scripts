#!/bin/bash
#
#
# Clones everything that is needed for LineageOS-16.0
# for the Lenovo Vibe K5 (A6020)
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

# Remove specific directories
echoText "Removing specified directories"

rm -rf h*/q*/bt-caf h*/q*/media-caf/msm8916 h*/q*/audio-caf/msm8916 h*/q*/display-caf/msm8916 h*/interfaces h*/q*/wlan h*/q*/wlan-caf frameworks/av vendor/qcom/opensource/dataservices external/tinycompress

# clone all required sources (including HAls and device sources)
echoText "Cloning all sources/HALs"

git clone https://github.com/Yash-Garg/pie_device_lenovo_A6020 -b lineage-16.0 device/lenovo/A6020
git clone https://github.com/Yash-Garg/pie_vendor_lenovo_A6020 -b lineage-16.0 vendor/lenovo
git clone https://github.com/Yash-Garg/android_kernel_lenovo_msm8916 -b lineage-16.0 kernel/lenovo/msm8916
git clone https://github.com/A6020-pie/android_vendor_qcom_opensource_dataservices -b pie vendor/qcom/opensource/dataservices
git clone https://github.com/A6020-pie/platform_hardware_qcom_audio -b pie-caf-8916 hardware/qcom/audio-caf/msm8916
git clone https://github.com/A6020-pie/platform_hardware_qcom_display -b pie-caf-8916 hardware/qcom/display-caf/msm8916
git clone https://github.com/A6020-pie/platform_hardware_qcom_media -b pie-caf-8916 hardware/qcom/media-caf/msm8916
git clone https://github.com/A6020-pie/platform_hardware_qcom_wlan -b pie hardware/qcom/wlan
git clone https://github.com/A6020-pie/platform_hardware_qcom_wlan -b pie-caf hardware/qcom/wlan-caf
git clone https://github.com/A6020-pie/android_external_tinycompress -b pie external/tinycompress
git clone https://github.com/A6020-pie/android_hardware_interfaces -b pie hardware/interfaces
git clone https://github.com/LineageOS/android_packages_resources_devicesettings -b lineage-16.0 packages/resources/devicesettings
git clone https://github.com/A6020-pie/platform_frameworks_av -b pie frameworks/av
git clone https://github.com/A6020-pie/platform_hardware_qcom_bt -b pie-caf hardware/qcom/bt-caf
git clone https://github.com/LineageOS/android_device_qcom_sepolicy-legacy -b lineage-16.0 device/qcom/sepolicy-legacy

# Setup env before building
# shellcheck disable=SC1090
. build/env*

## Pick all changes required for our device
echoText "Picking changes that are required"

# bionic
repopick 223067
repopick 223943 -f

# external/perfetto
repopick 223413

# system/core
repopick 224264

echoText "Script success!"
