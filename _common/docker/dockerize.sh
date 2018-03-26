#!/usr/bin/env bash
#
# provision script; install Dockerize.
#
# @see https://github.com/jwilder/dockerize/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/jwilder/dockerize/releases
# @see https://hub.docker.com/r/jwilder/dockerize/tags/
#
readonly DOCKERIZE_VERSION=$DOCKER_DOCKERIZE_VERSION
readonly DOCKERIZE_TARBALL=dockerize-linux-amd64-v$DOCKERIZE_VERSION.tar.gz
readonly DOCKERIZE_URLBASE=https://github.com/jwilder/dockerize/releases/download
readonly DOCKERIZE_TAR_URL=$DOCKERIZE_URLBASE/v$DOCKERIZE_VERSION/$DOCKERIZE_TARBALL

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
# Dockerize related stuff
#

echo "==> Installing dockerize"
curl -o dockerize.tar.gz -L $DOCKERIZE_TAR_URL
tar xvzf dockerize.tar.gz
rm *.tar.gz
chmod a+x dockerize
chown root dockerize
chgrp root dockerize
mv dockerize /usr/local/bin/dockerize-$DOCKERIZE_VERSION
ln -s dockerize-$DOCKERIZE_VERSION /usr/local/bin/dockerize
