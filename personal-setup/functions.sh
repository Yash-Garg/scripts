#!/usr/bin/env bash
#
# Copyright (C) Harsh Shandilya <msfjarvis@gmail.com>
# Copyright (C) Yash-Garg <yash.garg@outlook.in>
# SPDX-License-Identifier: GPL-3.0-only
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

function weather {
    if [ "$(tput cols)" -lt 125 ]; then # 125 is min size for correct display
        curl "wttr.in/~${1:-Ghaziabad}?0"
    else
        curl "wttr.in/~${1:-Ghaziabad}"
    fi
}

function reboot {
  echo "Do you really wanna reboot??"
  read -r confirmation
  case "${confirmation}" in
      'y'|'Y'|'yes') exec "$(command -v reboot)" ;;
      *) ;;
  esac
}

function fao {
    if [ -z "${1}" ]; then
        echoText "Supply a filename moron"
        return
    else
        local SEARCH_DIR
        SEARCH_DIR="."
        [ -z "${2}" ] || SEARCH_DIR="${2}"
        nano -L "$(find "${SEARCH_DIR}" -name "${1}.*")"
    fi
}

# shellcheck disable=SC1090
function loadbash {
    source ~/.bashrc
}

# shellcheck disable=SC1090
function loadzsh {
    source ~/.zshrc
}

function lolsay {
    cowsay "${@}" | lolcat
}

function foreversay {
    until ! lolsay "${@}"; do sleep 0; done
}

function imgur {
    local FILE; FILE="${1}"
    curl --request POST --url https://api.imgur.com/3/image --header "authorization: Client-ID ${IMGUR_API_KEY}" \
         --header 'content-type: multipart/form-data;' -F "image=@${FILE:?}" 2>/dev/null \
         | jq .data.link | sed 's/"//g' | xclip -rmlastnl -selection clipboard
}

function ygclone {
    git clone https://github.com/Yash-Garg/"$1"
}

function clone {
    git clone https://github.com/"$1"
}

function mkcd {
#shellcheck disable=SC2164
    mkdir -p "$1" && cd "$1"
}
