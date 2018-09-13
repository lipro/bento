# Docker enabled Bento by Li-Pro.Net

[![Build Status](http://img.shields.io/travis/lipro/docker-enabled-bento.svg)][travis]

This is an inofficial fork of [Bento](http://chef.github.io/bento/) with some minor extensions to provide Docker enabled [Vagrant](https://www.vagrantup.com/) base boxes. A subset of templates are built and published to the [li-pro.net](https://app.vagrantup.com/lipro) on Vagrant Cloud.

Bento is a project that encapsulates [Packer](https://www.packer.io/) templates for building [Vagrant](https://www.vagrantup.com/) base boxes. A subset of templates are built and published to the [bento org](https://app.vagrantup.com/bento) on Vagrant Cloud. These published boxes serve as the default boxes for [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant/).

### Using Public Boxes

Adding a lipro box to Vagrant

```
$ vagrant box add lipro/ubuntu-16.04-docker-ce
```

Using a lipro box in a Vagrantfile

```
Vagrant.configure("2") do |config|
  config.vm.box = "lipro/ubuntu-16.04-docker-ce"
end
```

### Building Boxes

See the original [Bento](http://chef.github.io/bento/) project for common documentation.

#### Requirements

- [Packer](https://www.packer.io/)
- At least one of the following virtualization providers:
  - [VirtualBox](https://www.virtualbox.org)
  - [VMware Fusion](https://www.vmware.com/products/fusion.html)
  - [VMware Workstation](https://www.vmware.com/products/workstation.html)
  - [Parallels Desktop](http://www.parallels.com/products/desktop)
  - [KVM](https://www.linux-kvm.org/page/Main_Page) *
  - [Hyper-V](https://technet.microsoft.com/en-us/library/hh831531(v=ws.11).aspx) *

\***NOTE:** support for these providers is considered experimental and corresponding Vagrant Cloud images may or may not exist.

#### Using `packer`

To build an Docker CE enabled Ubuntu 16.04 box for only the VirtualBox provider:

```
$ cd ubuntu
$ packer build -only=virtualbox-iso ubuntu-16.04-docker-ce.json
```

To build Docker CE enabled Ubuntu 16.04 boxes for all possible providers (simultaneously):

```
$ cd ubuntu
$ packer build ubuntu-16.04-docker-ce.json
```

To build Docker CE enabled Ubuntu 16.04 boxes for all providers except VMware and Parallels:

```
$ cd centos
$ packer build -except=parallels-iso,vmware-iso ubuntu-16.04-docker-ce.json
```

If the build is successful, ready to import box files will be in the `builds` directory at the root of the repository.

\***NOTE:** box_basename can be overridden like other Packer vars with `-var 'box_basename=ubuntu-16.04'`

#### Using `bento`

To build an Docker CE enabled Ubuntu 16.04 box for only the VirtualBox provider:

```
$ bento build -only=virtualbox-iso ubuntu/ubuntu-16.04-docker-ce.json
```

### Proprietary Templates

Templates for operating systems only available via license or subscription are also available in the repository, these include but are not limited to: Mac OS X, Red Hat Enterprise Linux, and SUSE Linux Enterprise. As the ISOs are not publicly available the URL values will need to be overridden as appropriate. We rely on the efforts of those with access to licensed versions of the operating systems to keep these up-to-date.

### Networking/Firewalls

Most of the providers expect unrestricted access to networking in order to build as expected. We can't enumerate all possible firewall configurations but include some snippets below that might be useful to users.

#### Windows

```
$VS = "Standardswitch"
$IF_ALIAS = (Get-NetAdapter -Name "vEthernet ($VS)").ifAlias
New-NetFirewallRule -Displayname "Allow incomming from $VS" -Direction Inbound -InterfaceAlias $IF_ALIAS -Action Allow
```

#### macOS / OSX

See this [wiki page](https://github.com/chef/bento/wiki/macOS)

## Bugs and Issues

Please use GitHub issues to report bugs, features, or other problems **with focus of changes in the lipro branches**.

Please use GitHub issues from the original [Bento](http://chef.github.io/bento/) project to report all other bugs, features, or other problems.

## Related projects

* https://github.com/boxcutter
* https://github.com/mcandre/packer-templates
* https://github.com/timsutton/osx-vm-templates
* https://github.com/ferventcoder/vagrant-windows-puppet/tree/master/baseboxes

## License & Authors

See the original [Bento](http://chef.github.io/bento/) project for more details about the original license:

```text
Copyright 2012-2017, Chef Software, Inc. (<legal@chef.io>)
Copyright 2011-2012, Tim Dysinger (<tim@dysinger.net>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

The Docker enabled templates here in this repository were created from:

- Author: Stephan Linz ([linz@li-pro.net](mailto:linz@li-pro.net))

[travis]: https://travis-ci.org/lipro/docker-enabled-bento

