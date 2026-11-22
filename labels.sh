#!/usr/bin/env bash
###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# Shared OCI image labels, sourced by the create_*_image.sh scripts.
#
# See https://github.com/opencontainers/image-spec/blob/main/annotations.md
#
# ex.
#   > set_oci_labels {container} {title} {description} {version} [base]
#
# Pass "base" as the fifth argument to also record the image the container
# was created from (org.opencontainers.image.base.*). Leave it out when the
# container is built from one of our own local images, so the base labels
# inherited from that image (the upstream distro image) are kept.
#

# Licenses of the software this project puts in the image: curl itself and
# the MIT licensed scripts from this repository. Distro packages in the image
# carry their own licenses; an SBOM is the place to list those.
OCI_LICENSES="curl AND MIT"

set_oci_labels() {
  local ctr=${1}
  local title=${2}
  local description=${3}
  local version=${4}
  local with_base=${5:-}

  local created revision
  # honour SOURCE_DATE_EPOCH so reproducible builds get a stable value
  if [[ -n "${SOURCE_DATE_EPOCH:-}" ]]; then
    created=$(date -u -d "@${SOURCE_DATE_EPOCH}" +%Y-%m-%dT%H:%M:%SZ)
  else
    created=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  fi
  revision=${GITHUB_SHA:-$(git rev-parse HEAD 2>/dev/null || true)}

  # drop legacy, non-OCI labels set by earlier versions or inherited from them
  local legacy
  for legacy in maintainer name version docker.cmd; do
    buildah config --label "${legacy}-" "$ctr"
  done

  buildah config \
    --label org.opencontainers.image.title="${title}" \
    --label org.opencontainers.image.description="${description}" \
    --label org.opencontainers.image.authors="James Fuller <jim.fuller@webcomposite.com>" \
    --label org.opencontainers.image.vendor="curl" \
    --label org.opencontainers.image.url="https://curl.se" \
    --label org.opencontainers.image.documentation="https://github.com/curl/curl-container#readme" \
    --label org.opencontainers.image.source="https://github.com/curl/curl-container" \
    --label org.opencontainers.image.licenses="${OCI_LICENSES}" \
    --label org.opencontainers.image.created="${created}" \
    "$ctr"

  if [[ -n "${version}" ]]; then
    buildah config --label org.opencontainers.image.version="${version}" "$ctr"
  fi
  if [[ -n "${revision}" ]]; then
    buildah config --label org.opencontainers.image.revision="${revision}" "$ctr"
  fi

  if [[ "${with_base}" == "base" ]]; then
    local base_name base_digest
    base_name=$(buildah inspect --format '{{.FromImage}}' "$ctr")
    base_digest=$(buildah inspect --format '{{.FromImageDigest}}' "$ctr")
    if [[ -n "${base_name}" ]]; then
      buildah config --label org.opencontainers.image.base.name="${base_name}" "$ctr"
    fi
    if [[ -n "${base_digest}" ]]; then
      buildah config --label org.opencontainers.image.base.digest="${base_digest}" "$ctr"
    fi
  fi
}
