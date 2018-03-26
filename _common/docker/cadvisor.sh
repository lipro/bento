#!/usr/bin/env bash
#
# provision script; install Docker Container Advisor.
#
# @see https://github.com/google/cadvisor/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/google/cadvisor/releases
# @see https://hub.docker.com/r/google/cadvisor/tags/
#
readonly CADVISOR_VERSION=$DOCKER_CADVISOR_VERSION
readonly CADVISOR_URLBASE=https://github.com/google/cadvisor/releases/download
readonly CADVISOR_EXE_URL=$CADVISOR_URLBASE/v$CADVISOR_VERSION/cadvisor

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
# Docker Container Advisor related stuff
#

echo "==> Installing docker cadvisor"
curl -o cadvisor -L $CADVISOR_EXE_URL
chmod a+x cadvisor
chown root cadvisor
chgrp root cadvisor
mv cadvisor /usr/local/bin/cadvisor-$CADVISOR_VERSION
ln -s cadvisor-$CADVISOR_VERSION /usr/local/bin/cadvisor

echo "==> Pulling docker cadvisor"
docker pull google/cadvisor:v$CADVISOR_VERSION

cat << EOF_CADVISOR > /etc/init/cadvisor.conf
description "cAdvisor"

start on filesystem and started docker
stop on runlevel [!2345]

#respawn

# @see https://github.com/google/cadvisor/blob/master/docs/running.md#standalone
script

    docker rm -f cadvisor  || true

    docker run  \
        --volume=/:/rootfs:ro          \
        --volume=/var/run:/var/run:rw  \
        --volume=/sys:/sys:ro          \
        --volume=/var/lib/docker/:/var/lib/docker:ro  \
        --publish=8080:8080  \
        --detach=true    \
        --restart=always \
        --name=cadvisor  \
        google/cadvisor:v$CADVISOR_VERSION

end script
EOF_CADVISOR
