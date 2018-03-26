#!/usr/bin/env bash
#
# provision script; install Docker host tools.
#
# @see https://github.com/William-Yeh/docker-host-tools/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/William-Yeh/docker-host-tools/tree/master
#
readonly HOSTTOOLS_VERSION=$DOCKER_HOSTTOOLS_VERSION
readonly HOSTTOOLS_URLBASE=https://raw.githubusercontent.com/William-Yeh/docker-host-tools
readonly HOSTTOOLS_EXE_URL=$HOSTTOOLS_URLBASE/$HOSTTOOLS_VERSION
readonly HOSTTOOLS_EXE=( docker-inspect-attr docker-mirror docker-rm-stopped  docker-rmi-repo )

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
# Docker host tools related stuff
#

echo "==> Installing docker host tools"
for item in "${HOSTTOOLS_EXE[@]}"; do
  curl -o $item  -L $HOSTTOOLS_EXE_URL/$item
  chmod a+x $item
  chown root $item
  chgrp root $item
  mv $item /usr/local/bin/$item-$HOSTTOOLS_VERSION
  ln -s $item-$HOSTTOOLS_VERSION /usr/local/bin/$item
done
