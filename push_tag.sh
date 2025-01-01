#!/bin/bash
# * =====================================================
# * Copyright © hk. 2022-2025. All rights reserved.
# * File name  : 1.sh
# * Author     : 苏木
# * Date       : 2025-01-01
# * ======================================================
##

# latest_tag=`git tag | sort -V | tail -1`

git push origin --delete V0.0.7
git tag -d V0.0.7

