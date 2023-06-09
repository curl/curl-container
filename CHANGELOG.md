Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

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
