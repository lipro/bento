#!/usr/bin/env bash
#
# provision script; install Docker Data Visualizing.
#
# @see https://github.com/justone/dockviz/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/justone/dockviz/releases
# @see https://hub.docker.com/r/nate/dockviz/tags/
#
readonly DOCKVIZ_VERSION=$DOCKER_DOCKVIZ_VERSION
readonly DOCKVIZ_URLBASE=https://github.com/justone/dockviz/releases/download
readonly DOCKVIZ_EXE_URL=$DOCKVIZ_URLBASE/v$DOCKVIZ_VERSION/dockviz_linux_amd64

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
# Docker Data Visualizing related stuff
#

#
# @see https://github.com/justone/dockviz#quick-start
#
echo "==> Installing docker data visualizing"
curl -o dockviz -L $DOCKVIZ_EXE_URL
chmod a+x dockviz
chown root dockviz
chgrp root dockviz
mv dockviz /usr/local/bin/dockviz-$DOCKVIZ_VERSION
ln -s dockviz-$DOCKVIZ_VERSION /usr/local/bin/dockviz

echo "==> Installing graphviz"
apt-get update
apt-get install -y -q graphviz
