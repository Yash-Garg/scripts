#!/bin/bash
#
# Copyright (C) Yash-Garg <ben10.yashgarg@gmail.com>
# SPDX-License-Identifier: GPL-v3.0-only
#
# This script helps in cloning sources from AOSP
# and pushing them to your own organisation
#
# Replace {REVISION} with the revision of the ROM like r1, r2
#

git clone https://android.googlesource.com/${1}/ ${1} -b android-9.0.0_{REVISION}
replace=`echo ${1} | sed 's/\//_/g'`
cd ${1} && git checkout -b 8.1.x
git push git@github.com:ORG_NAME/${replace} 9.0.x
cd -
