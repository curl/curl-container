#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
#  base images for reuse
#
# ex.
#   > create_base_image.sh {arch} {dist} {builder image} {deps} {resultant_image_name} {release_tag}
#

echo "####### creating curl base image."

# set default (will rarely change)
SO_NAME="libcurl.so.4.8.0"

# get invoke opts
platform=${1}
dist=${2}
builder_dist=${3}
deps=${4}
image_name=${5}
release_tag=${6}

# set base and platform
if [[ -n "${platform}" ]]; then
  echo "creating with platform=${platform}"
  ctr=$(buildah --platform "${platform}" from "${dist}")
else
  echo "creating ..."
  ctr=$(buildah from "${dist}")
fi
ctrmnt=$(buildah mount "$ctr")

# label/env
buildah config --label maintainer="James Fuller <jim.fuller@webcomposite.com>" "$ctr"
buildah config --label name="${image_name}" "$ctr"
buildah config --label version="${release_tag}" "$ctr"
buildah config --label docker.cmd="podman run -it quay.io/curl/${image_name}:${release_tag}" "$ctr"

# determine dist package manager
if [[ "$dist" =~ .*"alpine".* ]]; then
  package_manage_update="apk upgrade --no-cache"
  package_manage_add="apk add --no-cache"
fi
if [[ "$dist" =~ .*"fedora".* ]]; then
  package_manage_update="dnf upgrade"
  package_manage_add="dnf -y install"
fi
if [[ "$dist" =~ .*"debian".* ]]; then
  package_manage_update="apt-get update"
  package_manage_add="apt-get -y install"
fi

# deps
# shellcheck disable=SC2086
buildah run "$ctr" ${package_manage_update}
# shellcheck disable=SC2086
buildah run "$ctr" ${package_manage_add} ${deps}

# mount dev image containing build artifacts
if [[ -n "${platform}" ]]; then
  echo "creating with platform=${platform}"
  bdr=$(buildah --platform "${platform}" from "${builder_dist}")
else
  echo "creating ..."
  bdr=$(buildah from "${builder_dist}")
fi
bdrmnt=$(buildah mount "$bdr")

# copy build artifacts
cp    "$bdrmnt"/build/usr/local/bin/curl     "$ctrmnt"/usr/bin/curl
cp -r "$bdrmnt"/build/usr/local/include/curl "$ctrmnt"/usr/include/curl
cp -r "$bdrmnt"/build/usr/local/lib/*        "$ctrmnt"/usr/lib/.

# link
buildah run "$ctr" rm /usr/lib/libcurl.so.4 /usr/lib/libcurl.so
buildah run "$ctr" ln -s /usr/lib/"${SO_NAME}" /usr/lib/libcurl.so.4
buildah run "$ctr" ln -s /usr/lib/libcurl.so.4 /usr/lib/libcurl.so

# set ca bundle
buildah run "$ctr" curl https://curl.se/ca/cacert.pem -L -o /cacert.pem
buildah config --env CURL_CA_BUNDLE="/cacert.pem" "$ctr"

# setup curl_group and curl_user though it is not used directly in this image
buildah run "$ctr" addgroup -S curl_group
buildah run "$ctr" adduser -S curl_user -G curl_group

# set entrypoint
buildah config --cmd curl "$ctr"
buildah copy --chmod 755 --chown curl_user:curl_group "$ctr" etc/entrypoint.sh /entrypoint.sh
#buildah run "$ctr" run chgrp -R 0 /entrypoint.sh
#buildah run "$ctr" run chmod -R g+rwX /entrypoint.sh

buildah config --entrypoint '["/entrypoint.sh"]' "$ctr"

# label image
buildah config --label org.opencontainers.image.source="https://github.com/curl/curl-container" "$ctr"
buildah config --label org.opencontainers.image.description="minimal base image for curl" "$ctr"
buildah config --label org.opencontainers.image.licenses="MIT" "$ctr"

# set working directory
buildah config --workingdir /home/curl_user "$ctr"

# commit image
buildah commit "$ctr" "${image_name}" # --disable-compression false --squash --sign-by --tls-verify
