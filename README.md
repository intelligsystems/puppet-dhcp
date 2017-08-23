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

``` sh
puppet module install intelligsystems-dhcp
```

### What dhcp affects

* List of files and directories:
``` sh
.
├── examples
│   ├── failover.pp
│   ├── hosts.pp
│   ├── init.pp
│   └── subnet.pp
├── files
├── Gemfile
├── LICENSE
├── manifests
│   ├── config.pp
│   ├── init.pp
│   ├── install.pp
│   ├── params.pp
│   ├── service.pp
│   └── tests.pp
├── metadata.json
├── Rakefile
├── README.md
├── spec
│   ├── classes
│   │   └── init_spec.rb
│   └── spec_helper.rb
└── templates
    └── dhcpd_conf.erb
```
* It requires puppetlabs-stdlib, version_requirement: >= 1.0.0.
* Attention!!! This module broadcasts IP addresses.
  It can provide a lot of changes in your network.
  Please make sure that you know what DHCP server does.  

### Setup Requirements

* Puppet.
* Linux system with root privileges.

### Beginning with dhcp

The very basic steps needed for a user to get the module up and running.

``` puppet
include ::dhcp
```

## Usage

Simple example how to use this module:

``` puppet
class { 'dhcp':
  domain_name         => 'example.org',
  domain_name_servers => [ 'ns1.example.org', 'ns2.example.org' ],
  subnet              => {
    '10.10.10.0 netmask 255.255.255.0' => {
      'range'                    => '10.10.10.5 10.10.10.10',
      'option routers'           => '10.10.10.1',
      'option broadcast-address' => '10.10.10.255'
    }
  },
}
```
Example how to use this module with failover option:

``` puppet
node 'node1.example.org' {
  class { 'dhcp':
    domain_name_servers => [ '192.168.50.249', '192.168.50.250' ],
    failover            => [
      {
        'peer'         => 'primary',
        'peer address' => '192.168.50.243'
      }
    ],
    subnet              => {
      '192.168.50.0 netmask 255.255.255.0' => {
        'range'                    => '192.168.50.100 192.168.50.199',
        'option routers'           => '192.168.50.1',
        'option broadcast-address' => '192.168.50.255'
      }
    },
  }
}
node 'node2.example.org' {
  class { 'dhcp':
    domain_name_servers => [ '192.168.50.249', '192.168.50.250' ],
    failover            => [
      {
        'peer'         => 'secondary',
        'peer address' => '192.168.50.245'
      }
    ],
    subnet              => {
      '192.168.50.0 netmask 255.255.255.0' => {
        'range'                    => '192.168.50.100 192.168.50.199',
        'option routers'           => '192.168.50.1',
        'option broadcast-address' => '192.168.50.255'
      }
    },
  }
}
```

## Reference

Classes: 
  * dhcp::init 
  * dhcp::params 
  * dhcp::install 
  * dhcp::config 
  * dhcp::service

Facts: 
  * osfamily 
  * ipaddress 
  * domain

## Limitations

This module has been tested on Ubuntu 17.04, Debian 8 and CentOS 7 distribution already.
It will be testing soon on another systems. 

## Development

Soon...

## Release Notes.

dhcp 0.1.0 version:
  * base module

dhcp 0.1.1 version: 
  * puppet-lint fix
  * modified README

dhcp 0.1.2 version:
  * modified README
  * replaced all scope variables $:: with the $facts[]
  * added reverse compatibility for puppet 2.7.20
  * replaced File[dhcp::dhcp_conf] to File[dhcp::dhcpd_conf] in manifest/service.pp
  * modified templates/dhcpd_conf.erb to avoid add failover option to subnet without failover 'primary' or 'secondary' option (see changelog)

* [Relaeases](https://github.com/intelligsystems/puppet-dhcp/releases)
* [See changelog](https://github.com/intelligsystems/puppet-dhcp/commits/master)
