#!/usr/bin/env bash
#
# provision script; install Software-Defined Networking for Linux Containers.
#
# @see https://github.com/jpetazzo/pipework/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/jpetazzo/pipework/blob/master/pipework
#
readonly PIPEWORK_VERSION=$DOCKER_PIPEWORK_VERSION
readonly PIPEWORK_URLBASE=https://raw.githubusercontent.com/jpetazzo/pipework
readonly PIPEWORK_EXE_URL=$PIPEWORK_URLBASE/$PIPEWORK_VERSION/pipework

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
# Pipework related stuff
#

echo "==> Installing pipework"
curl -o pipework -L $PIPEWORK_EXE_URL
chmod a+x pipework
chown root pipework
chgrp root pipework
mv pipework /usr/local/bin/pipework-$PIPEWORK_VERSION
ln -s pipework-$PIPEWORK_VERSION /usr/local/bin/pipework
