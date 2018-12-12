#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#

sudo apt install gettext python3 python3-dev python3-pip python3-setuptools python3-wheel -y
sudo adduser --disabled-password --gecos "" bot
sudo -H -u bot bash -c "cd /home/bot; git clone https://github.com/krypticallusion/mau_mau_bot; chmod +x mau_mau_bot/bot.py"
sudo -H -u bot bash -c "cd /home/bot; cd mau_mau_bot/locales; bash compile.sh"
sudo -H -u bot bash -c "cd /home/bot; cd mau_mau_bot; cp config.json.example config.json; nano config.json"
sudo pip3 install -r /home/bot/mau_mau_bot/requirements.txt
curl https://raw.githubusercontent.com/MSF-Jarvis/systemd-units/master/uno-bot.service | sudo tee /etc/systemd/system/uno-bot.service
sudo systemctl daemon-reload
sudo systemctl start uno-bot
sudo systemctl enable uno-bot
echo "UNO BOT SETUP DONE !"
