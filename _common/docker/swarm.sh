#!/usr/bin/env bash
#
# provision script; install Docker Swarm.
#
# @see https://docs.docker.com/swarm/
# @see https://github.com/docker/swarm/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/docker/swarm/releases
# @see https://hub.docker.com/r/library/swarm/tags/
#
readonly SWARM_VERSION=$DOCKER_SWARM_VERSION

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
# Docker Swarm related stuff
#

#
# @see https://docs.docker.com/swarm/get-swarm/
#
echo "==> Pulling swarm"
docker pull swarm:$SWARM_VERSION

#
# de-duplicate ID for Swarm
# @see https://github.com/docker/swarm/issues/563
# @see https://github.com/docker/swarm/issues/362
#
rm -f /etc/docker/key.json  || true
