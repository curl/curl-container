###############################################################
#
# Copyright (C) 2023 James Fuller, <jim@webcomposite.com>, et al.
#
# SPDX-License-Identifier: curl-container
###############################################################
#
# used as dev environment for curl-container
#
#

from quay.io/buildah/stable:latest

RUN dnf --nodocs --setopt install_weak_deps=false -y install less git make podman qemu qemu-user-static buildah clamav clamav-freshclam

WORKDIR /opt/app-root/src/
