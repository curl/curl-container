Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## [8.12.0] - 2025-05-02
### Changed
- bump to curl 8.12.0
- bump to alpine:3.21.2

## [8.11.1] - 2024-12-11
### Changed
- bump to curl 8.11.1
- bump to alpine:3.21.0

## [8.11.0] - 2024-11-06
### Changed
- bump to curl 8.11.0

## [8.10.1] - 2024-09-18
### Changed
- bump to curl 8.10.1

## [8.10.0] - 2024-09-11
### Changed
- bump to curl 8.10.0
- bump to alpine:3.20.3

## [8.9.1] - 2024-07-30
### Changed
- bump to curl 8.9.1

## [8.9.0] - 2024-07-24
### Changed
- bump to curl 8.9.0
- bump to alpine 3.20.2

## [8.8.0] - 2024-05-22
### Changed
- bump to curl 8.8.0

## [8.7.1] - 2024-03-27
### Changed
- bump to curl 8.7.1

## [8.6.0] - 2024-01-31
### Changed
- bump to curl 8.6.0
- bump to alpine 3.19.1


## [8.5.0-1] - 2023-01-19
### Changed
- add libpsl
- bump to alpine 3.19.0

## [8.5.0] - 2023-12-06
### Changed
- bump to curl 8.5.0
- bump to alpine 3.18.5

## [8.4.0] - 2023-10-11
### Changed
- bump to curl 8.4.0
- bump to alpine 3.18.4
- build enabled --with-gssapi

## [8.3.1] - 2023-09-13
### Changed
- bump to curl 8.3.0
- bump to alpine 3.18.3


## [8.2.1] - 2023-07-26
### Changed
- bump to curl 8.2.1

## [8.2.0] - 2023-07-19
### Changed
- bump to curl 8.2.0
- bump to alpine 3.18.2

## [8.1.2-5] - 2023-06-14
### Changed
- added clamav and grype to security scan
- added user working directory
- skimmed apk cache
- added back arches (arm64, etc) by fixing issue #3

## [8.1.2-4] - 2023-06-08
### Changed
- fixed issue #12 by using oci format when pushing manifests V2s2

## [8.1.2-3] - 2023-06-08
### Changed
- fixed issue #12 by using oci format when pushing manifests V2s1
- fix entrypoint perms

## [8.1.2-2] - 2023-06-08
### Added 
- curl-dev-fedora:master
- curl-dev-debian:master
### Changed
- fixed issue #12 by using oci format when pushing manifests
- reduce cron CI jobs to daily
- temporarily remove arm64 arch from multiarch builds

## [8.1.2-1] - 2023-06-07
### Changed
- fixed and enhanced CI jobs
- fixed quay creds

## [8.1.2] - 2023-06-06
### Added
- created [curl-container repo](https://github.com/curl/curl-container/pull/1)
### Changed
- generate [curl:8.1.2 release](https://github.com/curl/curl/releases/tag/curl-8_1_2) images on [alpine 3.18.0](https://alpinelinux.org/posts/Alpine-3.18.0-released.html) 
