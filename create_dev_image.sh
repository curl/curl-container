#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# Create a dev image
#
# ex.
#   > create_dev_image.sh {arch} {base image} {compiler} {deps} {build_opts} {branch or tag} {resultant_image_name} {run_tests}
#

echo "####### creating curl dev image."

# get invoke opts
platform=${1}
dist=${2}
# shellcheck disable=SC2034
compiler_deps=${3}
deps=${4}
build_opts=${5}
branch_or_tag=${6}
image_name=${7}
run_tests=${8}

# set base and platform
if [[ -n "${platform}" ]]; then
  echo "creating with platform=${platform}"
  bdr=$(buildah --platform "${platform}" from "${dist}")
else
  echo "creating ..."
  bdr=$(buildah from "${dist}")
fi

# label/env
buildah config --label maintainer="James Fuller <jim.fuller@webcomposite.com>" "$bdr"
buildah config --label name="${image_name}" "$bdr"

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

# install deps using specific dist package manager
# shellcheck disable=SC2086
buildah run "$bdr" ${package_manage_update}
# shellcheck disable=SC2086
buildah run "$bdr" ${package_manage_add} ${deps}

# setup curl source derived from branch or tag
echo "get curl source"
buildah run "$bdr" mkdir /src
if [ "${branch_or_tag:0:4}" = "curl" ]; then
  # its a tag, retrieve release source
  # shellcheck disable=SC2154
  buildah run "$bdr" /usr/bin/curl -L -o curl.tar.gz "https://github.com/curl/curl/releases/download/${branch_or_tag}/curl-${release_tag}.tar.gz"
  buildah run "$bdr" tar -xf curl.tar.gz
  buildah run "$bdr" rm curl.tar.gz
  buildah run "$bdr" mv curl-"${release_tag}" /src/curl-"${release_tag}"
  buildah config --workingdir /src/curl-"${release_tag}" "$bdr"
else
  # its a branch, retrieve archive source
  buildah run "$bdr" /usr/bin/curl -L -o curl.tar.gz "https://github.com/curl/curl/archive/refs/heads/${branch_or_tag}.tar.gz"
  buildah run "$bdr" tar -xf curl.tar.gz
  buildah run "$bdr" rm curl.tar.gz
  buildah run "$bdr" mv curl-"${branch_or_tag}" /src/curl-"${branch_or_tag}"
  buildah config --workingdir /src/curl-"${branch_or_tag}" "$bdr"
fi

# build curl
buildah run "$bdr" autoreconf -fi
# shellcheck disable=SC2086
time buildah run "$bdr" ./configure --disable-dependency-tracking ${build_opts}
time buildah run "$bdr" make "-j$(nproc)"

# run tests
if [[ $run_tests -eq 1 ]]; then
  buildah run "$bdr" make test
fi

# install curl in /build
buildah run "$bdr" make DESTDIR="/build" install "-j$(nproc)"

# label image
buildah config --label org.opencontainers.image.source="https://github.com/curl/curl-container" "$bdr"
buildah config --label org.opencontainers.image.description="minimal dev image for curl" "$bdr"
buildah config --label org.opencontainers.image.licenses="MIT" "$bdr"

# commit image
buildah commit "$bdr" "${image_name}" # --disable-compression false --squash --sign-by --tls-verify
