#!/usr/bin/env bash
#
#
# provision script; install Docker Bench for Security.
#
# @see https://github.com/diogomonica/docker-bench-security/
# @see https://github.com/docker/docker-bench-security/
# @see https://dockerbench.com/
#

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#
# @see https://github.com/docker/docker-bench-security/releases
# @see https://hub.docker.com/r/docker/docker-bench-security/tags/
#
# readonly BENCHSEC_PROVIDER=diogomonica
readonly BENCHSEC_PROVIDER=docker
readonly BENCHSEC_VERSION=$DOCKER_BENCHSEC_VERSION

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
# Docker Bench for Security related stuff
#

echo "==> Pulling docker-bench-security"
docker pull $BENCHSEC_PROVIDER/docker-bench-security:$BENCHSEC_VERSION

cat << EOF_BENCH_SECURITY > /usr/local/bin/docker-bench-security-$BENCHSEC_VERSION
#!/bin/sh

exec docker run -it --label docker-bench-security="" \
    --net host --pid host \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd  \
    -v /etc:/etc \
    $BENCHSEC_PROVIDER/docker-bench-security:$BENCHSEC_VERSION
EOF_BENCH_SECURITY

chmod a+x /usr/local/bin/docker-bench-security-$BENCHSEC_VERSION
ln -s docker-bench-security-$BENCHSEC_VERSION /usr/local/bin/docker-bench-security
