#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# Create a multi arch image
# ex.
#   > create_multi.sh {
#
# get invoke opts
base=${1}
compiler=${2}
dev_deps=${3}
base_deps=${4}
build_opts=${5}
branch_or_ref=${6}
release_tag=${7}

echo "####### creating curl multi image."
buildah manifest create curl-base-multi:${release_tag}
buildah manifest create curl-multi:${release_tag}

# loop through supported arches
#for IMGTAG in "linux/amd64"  "linux/arm64" "linux/arm/v7" "linux/ppc64le" "linux/s390x" "linux/386" ; do
for IMGTAG in "linux/amd64" "linux/ppc64le" "linux/s390x" "linux/386" ; do
  pathname="${IMGTAG////-}"
  echo "building $IMGTAG : $pathname"
 	./create_dev_image.sh "$IMGTAG" ${base} ${compiler} "$dev_deps" "$build_opts" ${branch_or_ref} curl-dev-${pathname}:${release_tag} 0
 	./create_base_image.sh "$IMGTAG" ${base} localhost/curl-dev-${pathname}:${release_tag} "$base_deps" curl-base-${pathname}:${release_tag} ${release_tag}
 	buildah manifest add curl-base-multi:${release_tag} localhost/curl-base-${pathname}:${release_tag};
 	./create_appliance_image.sh "$IMGTAG" localhost/curl-base-${pathname}:${release_tag} curl-${pathname}:${release_tag} ${release_tag}
 	buildah manifest add curl-multi:${release_tag} localhost/curl-${pathname}:${release_tag};
done

