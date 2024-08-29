# Curl Container

[![build_master_multi_images](https://github.com/curl/curl-container/actions/workflows/build_master_multi.yml/badge.svg)](https://github.com/curl/curl-container/actions/workflows/build_master_multi.yml) 
[![build_latest_release_multi_images](https://github.com/curl/curl-container/actions/workflows/build_latest_release_multi.yml/badge.svg)](https://github.com/curl/curl-container/actions/workflows/build_latest_release_multi.yml)

This repository contains infrastructure/code that generates, tests and distributes the Official curl docker images 
available from the following registries:
* [quay.io](https://quay.io/curl/curl): curl images distributed by Quay.io
* [docker.io](https://hub.docker.com/r/curlimages/curl): curl images distributed by docker.io
* [github packages](https://github.com/orgs/curl/packages): development curl images

To pull an image:
```
> podman pull quay.io/curl/curl:latest
```
To run an image:
```
> podman run -it quay.io/curl/curl:latest -V
```

To use base image:
```
from quay.io/curl/curl-base:latest
RUN apk add jq
```

## Known limitations

- **IPv6 is supported**, however Docker/Podman do not support out by default.
  IPv6 must be enabled on network-level within Docker/Podman.

## How to verify images

To view curl image signature use [sigstore](https://sigstore.dev) `cosign tree`:
```commandline
> cosign tree ghcr.io/curl/curl-container/curl:master
```
Images are verified with this [public key](https://github.com/curl/curl-container/blob/main/cosign.pub):
```commandline
-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEwFTRXl79xRiAFa5ZX4aZ7Vkdqmji
5WY0zqc3bd6B08CsNftlYsu2gAqdWm0IlzoQpi2Zi5C437RTg/DgLQ6Bkg==
-----END PUBLIC KEY-----
```
Verify image using [cosign.pub](cosign.pub) public key using [sigstore](https://sigstore.dev) `cosign verify`:
```
> cosign verify --key cosign.pub ghcr.io/curl/curl-container/curl:master
```

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
* **curl-dev:master** - alpine based development environment
* **curl-dev-debian:master** - debian based development environment
* **curl-dev-fedora:master** - fedora based development environment

To use any of these development images; 
```
> podman run -it -v /Users/exampleuser/src/curl:/src/curl  ghcr.io/curl/curl-container/curl-dev-debian:master zsh
> ./buildconf
> ./configure
> make
```

**Note**- dev images are not specifically scanned for vulnerabilities and we currently _pin_ to latest which 
always has vulns ... **use at your own risk**. Perhaps we could consider _pinning_ to a later 'vintage'.

## Dependencies

Either of the following are required to use images:
* [podman](https://podman.io/getting-started/) 
* [docker](https://docs.docker.com/get-docker/)

The following are required to build or release images: 
* [buildah](https://buildah.io/): used for composing dev/build images
* [qemu-user-static](https://github.com/multiarch/qemu-user-static): used for building multiarch images

## Release

Curl images roughly match curl own release schedule, though we may release multiple versions
of the same curl version. In that instance we append a number (ex. 8.1.2-1) though do not rev
the version number used in registries.

The release process is as follows:

* create new branch (ex. v8.1.2)
* update [VERSION](https://github.com/curl/curl-container/blob/main/VERSION) to match curl version
* update [CHANGELOG.md](https://github.com/curl/curl-container/blob/main/CHANGELOG.md)
* raise prep PR, review and merge
* create [new release](https://github.com/curl/curl-container/releases/new) with new tag ( ex. 8.1.2 ) based on previously created branch
* new tag will trigger CI for publishing to quay/docker

