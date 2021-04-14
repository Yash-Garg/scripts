#!/usr/bin/env bash
#
# Copyright (C) Yash Garg <yash.garg@outlook.in>
# SPDX-License-Identifier: GPL-v3.0-only
#

GERRIT_USER=Yash-Garg

# shellcheck disable=SC2034
ANDROID_PLATFORM_ROOT="/home/yash/los"

DEFAULT_LINEAGE_BRANCH="lineage-16.0"
DEFAULT_PIXYS_BRANCH="pie"
DEFAULT_ARROW_BRANCH="arrow-9.x"
DEFAULT_AEX_BRANCH="9.x"
DEFAULT_AOSIP_BRANCH="pie"

LINEAGE_GERRIT_URL="review.lineageos.org"
PIXYS_GERRIT_URL="gerrit.pixysos.org"
ARROW_GERRIT_URL="review.arrowos.net"
AEX_GERRIT_URL="gerrit.aospextended.com"
AOSIP_GERRIT_URL="review.aosiprom.com"

DEFAULT_GERRIT="los"

function get_current_gerrit {
    if [[ "${DEFAULT_GERRIT}" == "pixys" ]]; then
        echo "${GERRIT_USER}@${PIXYS_GERRIT_URL}"
    elif [[ "${DEFAULT_GERRIT}" == "arrow" ]]; then
        echo "${GERRIT_USER}@${ARROW_GERRIT_URL}"
    elif [[ "${DEFAULT_GERRIT}" == "los" ]]; then
        echo "${GERRIT_USER}@${LINEAGE_GERRIT_URL}"
    elif [[ "${DEFAULT_GERRIT}" == "aex" ]]; then
        echo "${GERRIT_USER}@${AEX_GERRIT_URL}"
    elif [[ "${DEFAULT_GERRIT}" == "aosip" ]]; then
        echo "${GERRIT_USER}@${AOSIP_GERRIT_URL}"
    else
        return 1
    fi
}

function hook {
    local gitdir
    gitdir="$(git rev-parse --git-dir)"
    scp -p -P 29418 "$(get_current_gerrit)":hooks/commit-msg "${gitdir}"/hooks/
}

function reposync {
    repo sync -c --no-tags --force-sync -f -j10 "${@}"
}

# shellcheck disable=SC2032,SC2033,SC2029
# All the disabled warnings are false alarms that don't apply.
function gerrit {
    ssh -p 29418 "$(get_current_gerrit)" gerrit "${@}"
}

function gpush {
    declare -a PARAMS=("${@}")
    local BRANCH
    BRANCH="${DEFAULT_LINEAGE_BRANCH}"
    if [[ "${#PARAMS[@]}" -eq 2 ]]; then
        BRANCH="${PARAMS[0]}"
        if [[ "${PARAMS[1]}" == bypass ]]; then
            git push gerrit HEAD:refs/for/"${BRANCH}"
        else
            git push gerrit HEAD:refs/for/"${BRANCH}"/"${PARAMS[0]}"
        fi
    elif [[ "${#PARAMS[@]}" -eq 1 ]]; then
        git push gerrit HEAD:refs/for/"${BRANCH}"/"${PARAMS[0]}"
    else
        git push gerrit HEAD:refs/for/"${BRANCH}"
    fi
}

function pixyspush {
    gpush "${DEFAULT_PIXYS_BRANCH}" bypass
}

function aexpush {
    gpush "${DEFAULT_AEX_BRANCH}" bypass
}

function arrowpush {
    gpush "${DEFAULT_ARROW_BRANCH}" bypass
}

function aosippush {
    gpush "${DEFAULT_AOSIP_BRANCH}" bypass
}

function gfpush {
    local BRANCH
    BRANCH="${1}"
    if [[ "${BRANCH}" == "" ]]; then
        BRANCH="${DEFAULT_LINEAGE_BRANCH}"
    fi
    git push gerrit HEAD:refs/heads/"${BRANCH}"
}

function gffpush {
    BRANCH="${1}"
    if [[ "${BRANCH}" == "" ]]; then
        BRANCH="${DEFAULT_LINEAGE_BRANCH}"
    fi
    git push --force gerrit HEAD:refs/heads/"${BRANCH}"
}
