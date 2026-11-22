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

echo "####### creating curl image."

# shellcheck source=labels.sh
source "$(dirname "${BASH_SOURCE[0]}")/labels.sh"

# get invoke opts
platform=${1}
dist=${2}
image_name=${3}
release_tag=${4}

if [[ -n "${platform}" ]]; then
  echo "creating with platform=${platform}"
  ctr=$(buildah --platform "${platform}" from "${dist}")
else
  echo "creating ..."
  ctr=$(buildah from "${dist}")
fi

# assumes base image has setup curl_user
buildah config --user curl_user "$ctr"

# label image; base.name/base.digest are inherited from curl-base, so they
# name the upstream distro image rather than the local curl-base build
set_oci_labels "$ctr" "curl" "minimal image for curl" "${release_tag}"

# set working directory
buildah config --workingdir /home/curl_user "$ctr"

# commit image
buildah commit --squash "$ctr" "${image_name}"
