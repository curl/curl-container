# Curl Container

[![build_master_multi_images](https://github.com/curl/curl-container/actions/workflows/build_master_multi.yml/badge.svg)](https://github.com/curl/curl-container/actions/workflows/build_master_multi.yml) 
[![build_latest_release_multi_images](https://github.com/curl/curl-container/actions/workflows/build_latest_release_multi.yml/badge.svg)](https://github.com/curl/curl-container/actions/workflows/build_latest_release_multi.yml)

This repository contains infrastructure code that generates, tests and distributes the Official curl docker images 
available from the following registries:
* [quay.io](https://quay.io/curl/curl): curl images distributed by Quay.io
* [docker.io](https://hub.docker.com/repository/docker/curlimages/curl): curl images distributed by docker.io
* [github packages](https://github.com/orgs/curl/packages): development curl images

To pull an image:
```
> {docker|podman} pull quay.io/curl/curl:latest
```
To run an image:
```
> {docker|podman} run -it quay.io/curl/curl:latest -V
```

To use base image:
```
from quay.io/curl/curl-base:latest
RUN apk add jq
```

Images are signed using [sigstore](https://www.sigstore.dev/). To verify an image install 
sigstore cosign utility and use [cosign.pub](cosign.pub) public key:
```
> cosign verify --key cosign.pub ghcr.io/curl/curl-container/curl:master
```

**Note**- you need to login to container registry first before pulling it, ex. `{podman|docker} logon {registry}`.

## Contact

If you have problems, questions, ideas or suggestions, please [raise an issue](https://github.com/curl/curl-container/issues) or contact [curl-container team](curl-container@curl.se)
or [Jim Fuller](jim.fuller@webcomposite.com) directly.


## Development curl images

The following images are available via [github packages](https://github.com/orgs/curl/packages).

Master branch built regularly:
* **curl-dev:master** - curl-dev **master** branch 
* **curl-base:master** - curl-base **master** branch
* **curl:master** - curl **master** branch
* **curl-multi:master** - curl multiarch **master** branch
* **curl-base-multi:master** - curl-base multiarch **master** branch

A set of special case images built regularly:
* **curl-exp:master** - curl **master** branch built enabling expiremental features

Platform specific dev images built daily:
* **curl-dev-alpine:master** - alpine based development environment
* **curl-dev-debian:master** - debian based development environment
* **curl-dev-fedora:master** - fedora based development environment

To use any of these development images; 
```
> {docker|podman} run -v /src/my-curl-src:/src/curl curl/curl-dev-alpine:latest /bin/sh
$> cd /src/curl
$> ./buildconf
$> ./configure --with-openssl
$> make
```

## Dependencies

Either of the following are required to use images:
* [podman](https://podman.io/getting-started/) 
* [docker](https://docs.docker.com/get-docker/)

The following are required to build or release images: 
* [buildah](https://buildah.io/): used for composing dev/build images
* [qemu-user-static](https://github.com/multiarch/qemu-user-static): used for building multiarch images

**Note**- unfortunately buildah is not (yet) available for Apple/OSX.

## Release

Curl images roughly match curl own release schedule where the process is roughly as follows:

* create new branch (ex. v8.1.2)
* update VERSION to match curl version
* update CHANGELOG
* raise prep PR, review and merge
* create new release with new tag based on previously created branch

