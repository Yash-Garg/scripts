#!/usr/bin/env bash

# Copyright (C) Yash Garg <ben10.yashagarg@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only

result=$(curl -sf --data-binary @"${1:--}" https://del.dog/documents) || {
      echo "ERROR: failed to post document" >&2
      exit 1
}
key=$(jq -r .key <<< "${result}")
echo "https://del.dog/${key}"
[[ -z ${2} ]] && echo "https://del.dog/raw/${key}"
