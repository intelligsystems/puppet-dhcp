# dhcp

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with dhcp](#setup)
    * [What dhcp affects](#what-dhcp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with dhcp](#beginning-with-dhcp)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

DHCP puppet module to preapare dhcp linux server with failover option.
This module has been prepared on Debian 8.8 (Jessie) and Puppet 4.10 environment. 

## Setup

### What dhcp affects

* List of files and directories:
``` sh
  .:
  examples  files  Gemfile  manifests  metadata.json  Rakefile  README.md  spec  templates

  ./examples:
  failover.pp  hosts.pp  init.pp  subnet.pp

  ./files:

  ./manifests:
  config.pp  init.pp  install.pp  params.pp  service.pp  tests.pp

  ./spec:
  classes  spec_helper.rb

  ./spec/classes:
  init_spec.rb

  ./templates:
  dhcpd_conf.erb
```
* It requires puppetlabs-stdlib,version_requirement: >= 1.0.0.
* Attention!!! This module broadcast IP addresses.
  It can provide a lot of changes in your network.
  Please make sure that you know what DHCP server do.  

### Setup Requirements

* Puppet.
* Linux system with root privileges.

### Beginning with dhcp

The very basic steps needed for a user to get the module up and running. This

``` puppet
include ::dhcp
```

## Usage

Simple example how to use this module:

``` puppet
class { 'dhcp':
        domain_name             => 'example.org',
        domain_name_servers     => [ 'ns1.example.org', 'ns2.example.org' ],
        subnet                  => {
                '10.10.10.0 netmask 255.255.255.0'      => {
                        'range'                         => '10.10.10.5 10.10.10.10',
                        'option routers'                => '10.10.10.1',
                        'option broadcast-address'      => '10.10.10.255'
                }
        },
}
```

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This module has been tested on Ubuntu 17.04 and CentOS 7 distribution already.
It will be testing soon on another systems. 

## Development


## Release Notes.

dhcp 0.1.0 version module
