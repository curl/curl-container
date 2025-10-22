#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# ex.
#   > create_appliance_image.sh {arch} {dist} {base image} {resultant_image_name} {release_tag}
#
#

echo "####### creating curl image."

# get invoke opts
platform=${1}
dist=${2}
image_name=${3}
release_tag=${4}

if [[ -n $platform ]]; then
  echo "creating with platform=${platform}"
  ctr=$(buildah --platform ${platform} from ${dist})
else
  echo "creating ..."
  ctr=$(buildah from ${dist})
fi


# label/env
buildah config --label maintainer="James Fuller <jim.fuller@webcomposite.com>" $ctr
buildah config --label name="${image_name}" $ctr
buildah config --label version="${release_tag}" $ctr
buildah config --label docker.cmd="podman run -it quay.io/curl/${image_name}:${release_tag}" $ctr

# assumes base image has setup curl_user
buildah config --user curl_user $ctr

# label image
buildah config --label org.opencontainers.image.source="https://github.com/curl/curl-container" $ctr
buildah config --label org.opencontainers.image.description="minimal image for curl" $ctr
buildah config --label org.opencontainers.image.licenses="MIT" $ctr

# set working directory
buildah config --workingdir /home/curl_user $ctr

# commit image
buildah commit $ctr "${image_name}" # --disable-compression false --squash --sign-by --tls-verify
