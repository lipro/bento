#!/usr/bin/env bash
#
# provision script; install Docker Generator.
#
# @see https://github.com/jwilder/docker-gen/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/jwilder/docker-gen/releases
# @see https://hub.docker.com/r/jwilder/docker-gen/tags/
#
readonly DOCKERGEN_VERSION=$DOCKER_DOCKERGEN_VERSION
readonly DOCKERGEN_TARBALL=docker-gen-linux-amd64-$DOCKERGEN_VERSION.tar.gz
readonly DOCKERGEN_URLBASE=https://github.com/jwilder/docker-gen/releases/download
readonly DOCKERGEN_TAR_URL=$DOCKERGEN_URLBASE/$DOCKERGEN_VERSION/$DOCKERGEN_TARBALL

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
# Docker Generator related stuff
#

#
# @see https://github.com/jwilder/docker-gen#installation
#
echo "==> Installing docker generator"
curl -o docker-gen.tar.gz -L $DOCKERGEN_TAR_URL
tar xvzf docker-gen.tar.gz
rm *.tar.gz
chmod a+x docker-gen
chown root docker-gen
chgrp root docker-gen
mv docker-gen /usr/local/bin/docker-gen-$DOCKERGEN_VERSION
ln -s docker-gen-$DOCKERGEN_VERSION /usr/local/bin/docker-gen
