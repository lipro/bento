#!/usr/bin/env bash
#
# provision script; install Docker Compose.
#
# @see https://docs.docker.com/compose/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/docker/compose/releases
#
readonly COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION
readonly COMPOSE_URLBASE=https://github.com/docker/compose/releases/download
readonly COMPOSE_EXE_URL=$COMPOSE_URLBASE/$COMPOSE_VERSION/docker-compose-Linux-x86_64

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
# Docker Compose related stuff
#

#
# @see https://docs.docker.com/compose/install/
# @see https://github.com/docker/compose#installation-and-documentation
#
echo "==> Installing docker compose"
curl -o docker-compose -L $COMPOSE_EXE_URL
chmod a+x docker-compose
chown root docker-compose
chgrp root docker-compose
mv docker-compose /usr/local/bin/docker-compose-$COMPOSE_VERSION
ln -s docker-compose-$DOCKER_COMPOSE_VERSION /usr/local/bin/docker-compose
