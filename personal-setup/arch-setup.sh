#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

sudo pacman -Syyu
sudo pacman -S neofetch firefox filezilla telegram-desktop etcher git mariadb

git config --global user.name "Yash Garg"
git config --global user.email "ben10.yashgarg@gmail.com"

yaourt -S hyper anydesk sublime-text-dev spotify --noconfirm
