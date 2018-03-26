#!/usr/bin/env bash
#
# provision script; install Docker Machine.
#
# @see https://docs.docker.com/machine/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# https://github.com/docker/machine/releases/
#
readonly MACHINE_VERSION=$DOCKER_MACHINE_VERSION
readonly MACHINE_URLBASE=https://github.com/docker/machine/releases/download
readonly MACHINE_EXE_URL=$MACHINE_URLBASE/v$MACHINE_VERSION/docker-machine-Linux-x86_64

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
# Docker Machine related stuff
#

#
# @see https://docs.docker.com/machine/install-machine/
# @see https://github.com/docker/machine#installation-and-documentation
#
echo "==> Installing docker machine"
curl -o docker-machine -L $MACHINE_EXE_URL
chmod a+x docker-machine
chown root docker-machine
chgrp root docker-machine
mv docker-machine /usr/local/bin/docker-machine-$MACHINE_VERSION
ln -s docker-machine-$MACHINE_VERSION /usr/local/bin/docker-machine
