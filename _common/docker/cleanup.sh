#!/usr/bin/env bash
#
# provision script; clean up Docker environment.
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

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
# Docker environment related stuff
#

#
# @see https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430
#
echo "==> Cleaning up unused docker resources"
docker network rm `docker network ls --no-trunc -qf driver=bridge`  || true
docker volume rm `docker volume ls --no-trunc -qf dangling=true`  || true
docker image rm `docker image ls --no-trunc -qf dangling=true`  || true

echo "==> Cleaning up docker installation"
docker rm `docker ps --no-trunc -qa`  || true
docker rmi -f busybox  || true
