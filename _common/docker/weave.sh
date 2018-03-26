#!/usr/bin/env bash
#
# provision script; install Docker multi-host networking.
#
# @see https://github.com/weaveworks/weave/
# @see https://www.weave.works/oss/net/
# @see https://www.weave.works/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/weaveworks/weave/releases
# @see https://hub.docker.com/r/weaveworks/weave/tags/
# @see https://hub.docker.com/u/weaveworks/
#
readonly WEAVE_VERSION=$DOCKER_WEAVE_VERSION
readonly WEAVE_URLBASE=https://github.com/weaveworks/weave/releases/download
readonly WEAVE_EXE_URL=$WEAVE_URLBASE/v$WEAVE_VERSION/weave

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
# Weave related stuff
#

#
# @see https://github.com/weaveworks/weave/#further-information
# @see https://www.weave.works/docs/net/latest/installing-weave/
#
echo "==> Installing weave"
curl -o weave -L $WEAVE_EXE_URL
chmod a+x weave
chown root weave
chgrp root weave
mv weave /usr/local/bin/weave-$WEAVE_VERSION
ln -s weave-$WEAVE_VERSION /usr/local/bin/weave

echo "==> Pulling weave"
weave setup
