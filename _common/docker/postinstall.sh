#!/usr/bin/env bash
#
# provision script; post-install for Docker.
#
# @see https://docs.docker.com/install/linux/linux-postinstall/
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
# Docker Engine related stuff
#

#
# Manage Docker as a non-root user
# @see https://docs.docker.com/install/linux/linux-postinstall/
#      --> #manage-docker-as-a-non-root-user
# 
echo "==> Add vagrant user to docker group"
usermod -aG docker vagrant

#
# Avoid warning about memory and swap accounting.
# @see https://docs.docker.com/install/linux/linux-postinstall/
#      --> #your-kernel-does-not-support-cgroup-swap-limit-capabilities
#
echo "==> Enable memory and swap accounting"
sed -i -e \
  's/^GRUB_CMDLINE_LINUX="\(.*\)"/GRUB_CMDLINE_LINUX="\1cgroup_enable=memory swapaccount=1 "/' \
  /etc/default/grub \
  || true
update-grub

#
# Allow access to the remote API through a firewall
# @see https://docs.docker.com/install/linux/linux-postinstall/
#      --> #allow-access-to-the-remote-api-through-a-firewall
#
echo "==> Preparing UFW to enable forwarding"
sed -i -e \
  's/^DEFAULT_FORWARD_POLICY=".\+"/DEFAULT_FORWARD_POLICY="ACCEPT"/' \
  /etc/default/ufw \
  || true
ufw reload

#
# override "insecure-registry" error for private registry to ease testing
# @see http://stackoverflow.com/a/27163607/714426
#
echo "==> Override 'insecure-registry' error for private registry"
cat << "EOF_REGISTRY" >> /etc/default/docker

# allow Docker Remote API
DOCKER_OPTS="$DOCKER_OPTS -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"

# allow HTTP access to private registry "registry.com"
DOCKER_OPTS="$DOCKER_OPTS --insecure-registry registry.com"
#DOCKER_OPTS="--insecure-registry 10.0.0.0/24 --insecure-registry registry.com"

EOF_REGISTRY
