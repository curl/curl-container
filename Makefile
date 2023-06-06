.DEFAULT_GOAL := all

container_ids=`buildah ls --format "{{.ContainerID}}"`

# default setttings for official curl images
base=docker.io/alpine:3.18.0
arch=""
compiler="gcc"
build_opts=" --enable-static --disable-ldap --enable-ipv6 --enable-unix-sockets -with-ssl --with-libssh2 --with-nghttp2=/usr"
dev_deps="libssh2 libssh2-dev libssh2-static autoconf automake build-base groff openssl curl-dev python3 python3-dev libtool curl stunnel perl nghttp2 brotli brotli-dev"
base_deps="brotli brotli-dev libssh2 nghttp2-dev libidn2"

##############################################
# debian dev image
##############################################
#
#  > make branch_or_ref=master release_tag=master build_debian
#
build_debian:
	./create_dev_image.sh ${arch} docker/debian:latest ${compiler} ${dev_deps} ${build_opts} ${branch_or_ref} curl-dev-debian:${release_tag}

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
# scan
#############################
#
#  > make dist_name=curl release_tag=master scan
#
scan:
	systemctl --user enable --now podman.socket
	curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo bash -s -- -b /usr/local/bin v0.32.0
	trivy image ${dist_name}:${release_tag}
# 	wget -qO - https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo bash -s -- -b /usr/local/bin
# 	grype ${dist_name}:${release_tag}

#############################
# multibuild
#############################
#
#
#  > make branch_or_ref=master release_tag=master multibuild
#
multibuild:
	./create_multi.sh ${base} ${compiler} ${dev_deps} ${base_deps} ${build_opts} ${branch_or_ref} ${release_tag}

#############################
# utilities
#############################
#
#
clean:
	buildah rm $(container_ids)
run_curl_dev_master:
	# assumes git checkout of curl at ../curl
	podman run --privileged -it -v /opt/app-root/curl:/src/curl:z localhost/curl-dev:master
run_curl_base_master:
	# assumes git checkout of curl at ../curl
	podman run -it -v ../curl:/src/curl:z localhost/curl-base:master
run_curl_master:
	# assumes git checkout of curl at ../curl
	podman run -it -v ../curl:/src/curl:z localhost/curl:master

dev:
	podman-compose -f dev-compose.yml up

