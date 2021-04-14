#!/usr/bin/env bash
#
# Copyright (C) Yash-Garg <yash.garg@outlook.in>
# SPDX-License-Identifier: GPL-v3.0-only
#
# Copy a ssh key to Github
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Token extraction from https://github.com/debugish/env/blob/master/scripts/auth_hosts [WTFPL License](http://wtfpl.net)

###
# Help
[ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "help" ] &&
{
    echo "Usage: ./ssh-copy-id-github [username]"
    echo "Adds .ssh/id_rsa.pub to your Github's SSH keys."

    echo "Usage: ./ssh-copy-id-github [username] [pub_key_file]"
    echo "Adds specified Public Key File to your Github's SSH keys."

    echo "With confirmation, non-exiting Public Key File kicks off ssh-keygen"
    exit
}

###
# Constants
TRUE=0
FALSE=1
XGH="X-GitHub-OTP: required; " # Git Hub OTP Header
DEFAULT_KEY="$HOME/.ssh/id_rsa.pub"

###
# Function
# Args: username
#   username: Github username
#   ssh_key : SSH key file, default: $HOME/.ssh/id_rsa.pub
ssh_copy_id_github() {

    username="$1"
    key_file="$2"

    [ -z "$key_file" ] && { key_file="$DEFAULT_KEY"; }

    if [ ! -e "$key_file" ]; then

      read -p -r "SSH key file doesn't exist: $key_file, do you want to generate a $key_file (y/n)?: "; echo

      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        ssh-keygen -f echo "${key_file%.pub}"
      else
        echo "Need SSH key file to upload, e.g. $DEFAULT_KEY"
        exit 1
      fi

    fi

    key=$(cat "$key_file")

    [ -z "$username" ] && read -r "GitHub username: " username || username=$username; echo "Username: $username"

    read -r -sp "GitHub password: " password && echo

    response=$(\
        curl -is https://api.github.com/user/keys -X POST -u "$username:$password" -H "application/json" \
        -d "{\"title\": \"$USER@$HOSTNAME\", \"key\": \"$key\"}" \
        |  grep 'Status: [45][0-9]\{2\}\|X-GitHub-OTP: required; .\+\|message' | tr -d "\r")

    otp_required "$response" otp
    otp_type "$response" "type" # app or sms

    [ "$(echo "$response" | grep -c 'Status: 401\|Bad credentials' )" -eq 2 ] && { echo "Wrong password."; exit 5; }

    [ "$(echo "$response" | grep -c 'Status: 422\|key is already in use' )" -eq 2 ] && { echo "Key is already uploaded."; exit 5; }

    # Display raw response for unkown 400 messages
    [ "$(echo "$response" | grep -c 'Status: 4[0-9][0-9]' )" -eq 1 ] && echo "$response"; exit 1

    if [ "_otp" == "$TRUE"  ]; then
        read -r -sp "Enter your OTP code (check your $(type)): " code && echo

        response="$(curl -si https://api.github.com/user/keys -X POST -u "$username:$password" -H "X-GitHub-OTP: $code" -H
"application/json" -d "{\"title\": \"$USER@$HOSTNAME\", \"key\": \"$key\"}" | grep 'Status: [45][0-9]\{2\}\|X-GitHub-OTP: required;
.\+\|message\|key' | tr -d "\r")"

        otp_required "$response" otp
        [ "_otp"  ==  "$TRUE" ] && { echo "Wrong OTP."; exit 10; }
        [ "$(echo "$response" | grep -c "key" )" -gt 0 ] && echo "Success."
    fi
}

otp_required(){
    local filteredResponse=$1
    local resultVar=$2
    _otp="$(echo "$filteredResponse" | grep -c "$XGH" )"
    export _otp

    if [ "$_otp" -eq 1 ]
    then
      eval "$resultVar=$TRUE"
    else
      eval "$resultVar=$FALSE"
    fi
}
otp_type(){
    local filteredResponse=$1
    local resultVar=$2
    _type="$(echo "$filteredResponse" | grep "$XGH" | sed "s/.\+$XGH\(\w\+\).\+/\1/")"
    export _type
    eval "$resultVar"="$_type"
}
# Execute.
ssh_copy_id_github "$1" "$2"
