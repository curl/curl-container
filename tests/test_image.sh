#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# ex.
#   > test_image.sh {branch or tag}
#
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
echo "####### testing curl dev image."

# get invoke opts
dist=${1}
branch_or_tag=${2}

# create and mount image
ctr=$(buildah from ${dist}:${branch_or_tag})
ctrmnt=$(buildah mount $ctr)

# check file exists
if [[ ! -f "$ctrmnt/usr/bin/curl" ]]; then
    echo "/usr/bin/curl does not exist."
fi
if [[ ! -f "$ctrmnt/usr/lib/libcurl.so.4.8.0" ]]; then
    echo "/usr/lib/libcurl.so.4.8.0 does not exist."
fi

# check symlink exists and is not broken
if [ ! -L "$ctrmnt/usr/lib/libcurl.so.4" ] && [ ! -e "$ctrmnt/usr/lib/libcurl.so.4" ]; then
    echo "/usr/lib/libcurl.so.4 symlink does not exist or is broken."
fi
if [ ! -L "$ctrmnt/usr/lib/libcurl.so" ] && [ ! -e "$ctrmnt/usr/lib/libcurl.so"  ]; then
    echo "/usr/lib/libcurl.so symlink does not exist or is broken."
fi

# test running curl
buildah run $ctr /usr/bin/curl -V