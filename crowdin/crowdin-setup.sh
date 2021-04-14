#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <yash.garg@outlook.in>
# SPDX-License-Identifier: GPL-v3.0-only
#

# Script to setup environment for crowdin

sudo apt install python-git

curl -sSL https://get.rvm.io | bash -s stable --ruby

rvm all "do" gem install crowdin-cli
