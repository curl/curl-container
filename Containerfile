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

RUN dnf --nodocs --setopt install_weak_deps=false -y install less git make podman qemu-user-static buildah

COPY requirements.txt requirements.txt
RUN python3 -m ensurepip
RUN pip3 install --no-input -r requirements.txt

WORKDIR /opt/app-root/src/
