#!/bin/sh -eux
ubuntu_version="`lsb_release -r | awk '{print $2}'`";
major_version="`echo $ubuntu_version | awk -F. '{print $1}'`";

case "$PACKER_BUILDER_TYPE" in
hyperv-iso)
  # https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/supported-ubuntu-virtual-machines-on-hyper-v
  if [ "$major_version" -eq "14" ]; then
    # https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_14.04_LTS_-_Trusty_Tahr
    apt-get install -y hv-kvp-daemon-init linux-tools-virtual-lts-xenial linux-cloud-tools-virtual-lts-xenial;
  elif [ "$major_version" -eq "16" ]; then
    # https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_16.04_LTS_-_Xenial_Xerus
    apt-get install -y linux-tools-virtual-hwe-16.04 linux-cloud-tools-virtual-hwe-16.04;
  elif [ "$major_version" -ge "17" ]; then
    apt-get -y install linux-image-virtual linux-tools-virtual linux-cloud-tools-virtual;
  fi
esac
