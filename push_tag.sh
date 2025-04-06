#!/bin/bash
# * =====================================================
# * Copyright © hk. 2022-2025. All rights reserved.
# * File name  : 1.sh
# * Author     : 苏木
# * Date       : 2025-01-01
# * ======================================================
##

# latest_tag=`git tag | sort -V | tail -1`
# 删除tag
git tag -d tag_name
git push origin --delete tag_name

# 创建tag
git tag tag_name
git push origin tag_name
