#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

# Script to setup environment for crowdin

sudo apt install python-git
curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm all do gem install crowdin-cli
