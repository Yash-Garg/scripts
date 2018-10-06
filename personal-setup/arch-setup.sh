#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

sudo pacman -Syyu
sudo pacman -S neofetch firefox filezilla telegram-desktop etcher git mariadb gnupg
yaourt -S hyper anydesk sublime-text-dev spotify --noconfirm

gpg --import ../gpg_keys/ryzenbox_public.asc
gpg --import ../gpg_keys/ryzenbox_private.asc

git config --global user.name "Yash Garg"
git config --global user.email "ben10.yashgarg@gmail.com"
git config --global signing.key 40C0AECA98D94CBF
