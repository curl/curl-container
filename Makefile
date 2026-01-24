.DEFAULT_GOAL := all

container_ids=`buildah ls --format "{{.ContainerID}}"`

# default settings for official curl images
debian_base=docker.io/debian
fedora_base=docker.io/fedora
base=docker.io/alpine:3.23.0
arch=""
compiler="gcc"
dev_deps="git zsh libssh2 libssh2-dev libssh2-static autoconf automake build-base openssl curl-dev python3 python3-dev libtool curl perl nghttp2 brotli brotli-dev krb5-dev libpsl-dev zstd"
base_deps="brotli brotli-dev libssh2 nghttp2-dev libidn2 krb5 libpsl zstd"
build_opts="--enable-static --disable-ldap --enable-ipv6 --enable-unix-sockets --with-openssl --with-libssh2 --with-nghttp2=/usr --with-gssapi"

##############################################
# debian dev image
##############################################
#
#  > make branch_or_ref=master release_tag=master build_debian
#
build_debian:
	./create_dev_image.sh ${arch} ${debian_base} ${compiler} \
	  "zsh curl gcc libtool autoconf automake make perl libssl-dev libssh2-1 libssh2-1-dev libnghttp2-dev libbrotli-dev libzstd-dev libidn2-dev libpsl-dev" \
	  "--enable-ipv6 --enable-unix-sockets --with-openssl --with-libssh2 --with-nghttp2=/usr" \
	  ${branch_or_ref} curl-dev-debian:${release_tag}

##############################################
# fedora dev image
##############################################
#
#  > make branch_or_ref=master release_tag=master build_fedora
#
build_fedora:
	./create_dev_image.sh ${arch} ${fedora_base} ${compiler} \
	  "zsh curl gcc libtool perl openssl-devel libssh2-devel libnghttp2-devel brotli-devel libzstd-devel libidn2-devel libpsl-devel" \
	  "--enable-ipv6 --enable-unix-sockets --with-openssl --with-libssh2 --with-nghttp2=/usr" \
	  ${branch_or_ref} curl-dev-fedora:${release_tag}

##############################################
# build_alpine dev, base and appliance image
##############################################
#
#  > make branch_or_ref=master release_tag=master run_tests=1 build_arm64
#
build_arm64:
	./create_dev_image.sh "arm64" ${base} ${compiler} ${dev_deps} ${build_opts} ${branch_or_ref} curl-dev-linux-arm64:${release_tag} ${run_tests}
# 	./create_base_image.sh "linux/arm64" ${base} localhost/curl-dev-linux-arm64:${release_tag} ${base_deps} curl-base-linux-arm64:${release_tag} ${release_tag}
# 	./create_appliance_image.sh "linux/arm64" localhost/curl-base-linux-arm64:${release_tag} curl-linux-arm64:${release_tag} ${release_tag}

##############################################
# build_alpine dev, base and appliance image
##############################################
#
#  > make branch_or_ref=master release_tag=master run_tests=1 build_alpine
#
build_alpine:
	./create_dev_image.sh ${arch} ${base} ${compiler} ${dev_deps} ${build_opts} ${branch_or_ref} curl-dev:${release_tag} ${run_tests}
	./create_base_image.sh ${arch} ${base} localhost/curl-dev:${release_tag} ${base_deps} curl-base:${release_tag} ${release_tag}
	./create_appliance_image.sh ${arch} localhost/curl-base:${release_tag} curl:${release_tag} ${release_tag}

build_ref_images: build_alpine

#############################
# test
#############################
#
#  > make dist_name=curl branch_or_ref=master test
#
test:
	tests/test_image.sh ${dist_name} ${release_tag}

#############################
# feature test
#############################
#
# Runs nascent behave feature tests
#
#  > make feature-test
#
feature-test:
	behave tests

#############################
# scan
#############################
#
# Runs clamav, grype and trivy against image
#
#  > make image_name=localhost/curl:master scan
#
# Requires: grype trivy
#
# One way to install them:
#   curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin
#   curl -sSfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo bash -s -- -b /usr/local/bin v0.32.0
#
scan:
	podman save -o image.tar ${image_name}
	# Run clamav on image.tar
# 	freshclam
	clamscan image.tar
	# run grype on image.tar
	grype --version
	grype image.tar
	# run trivy on image.tar
	systemctl --user enable --now podman.socket | true
	trivy --version
	trivy image --input image.tar
	rm image.tar

#############################
# multibuild
#############################
#
#  > make branch_or_ref=master release_tag=master multibuild
#
multibuild:
	./create_multi.sh ${base} ${compiler} ${dev_deps} ${base_deps} ${build_opts} ${branch_or_ref} ${release_tag}

#############################
# utilities
#############################
#
clean:
	buildah rm $(container_ids)
dev:
	podman-compose -f dev-compose.yml up
