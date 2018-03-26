#!/usr/bin/env bash
#
# provision script; install Docker Community Edition.
#
# @see https://docs.docker.com/install/linux/docker-ce/ubuntu/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

readonly apt_url="https://download.docker.com/linux/ubuntu"
readonly key_url="$apt_url/gpg"

#
# @see $apt_url/trusty/stable/binary-amd64/Packages
#      17.03.0~ce-0~ubuntu-trusty
#      17.03.1~ce-0~ubuntu-trusty
#      17.03.2~ce-0~ubuntu-trusty
#      17.06.0~ce-0~ubuntu
#      17.06.1~ce-0~ubuntu
#      17.06.2~ce-0~ubuntu
#      17.09.0~ce-0~ubuntu
#      17.09.1~ce-0~ubuntu
#      17.12.0~ce-0~ubuntu
#      17.12.1~ce-0~ubuntu
#      18.03.0~ce-0~ubuntu
#
readonly ubuntu_version="`lsb_release -r | awk '{print $2}'`"
readonly ubuntu_codename="`lsb_release -c | awk '{print $2}'`"

case $DOCKER_CE_VERSION in
    17.03*)
        readonly debpkg_version="$DOCKER_CE_VERSION~ce-0~ubuntu-$ubuntu_codename"
        ;;
    *)
        readonly debpkg_version="$DOCKER_CE_VERSION~ce-0~ubuntu"
        ;;
esac

#==========================================================#

#
# error handling
#

do_error_exit() {
    echo { \"status\": $RETVAL, \"error_line\": $BASH_LINENO }
    exit $RETVAL
}

trap 'RETVAL=$?; echo "ERROR"; do_error_exit '  ERR
trap 'RETVAL=$?; echo "received signal to stop";  do_error_exit ' SIGQUIT SIGTERM SIGINT

# export trap to functions
set -E

#==========================================================#

#
# Docker Community Edition related stuff
#

if [ "$ubuntu_codename" = "trusty" ]; then
  echo "==> Installing recommended extra packages for $ubuntu_codename $ubuntu_version"
  apt-get update
  apt-get install -y -q linux-image-extra-$(uname -r) linux-image-extra-virtual
fi

echo "==> Installing packages to allow apt to use a repository over HTTPS"
apt-get update
apt-get install -y -q apt-transport-https ca-certificates curl software-properties-common

echo "==> Add Docker’s official GPG key"
curl -sSL $key_url | apt-key add -

echo "==> Setting up Docker’s stable repository"
add-apt-repository -y "deb [arch=amd64] $apt_url $ubuntu_codename stable"

echo "==> Installing docker community edition"
apt-get update
apt-get install -y -q docker-ce=$debpkg_version
