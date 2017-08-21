# Class: dhcp
# ===========================
#
# This class can be used for create and manage DHCP server based on Linux systems.
#
# Parameters
# ----------
#
# Document parameters here.
#
# @param package_manage [Boolean]
# 	If you set 'false' then a package is not installed.
#	Default: true
#
# @param package_ensure [Optional[String]]
# 	There are two possible function. 'present' means install module, 
# 	'absent' means uninstall module.
#	Default: present
#
# @param package_name [Optional[String]]
# 	Package name is definded in params.pp function. 
# 	It depends on distribution.  
#	Default: $dhcp::params::package_name
#
# @param package_provider [Optional[String]]
# 	Package provider is definded in params.pp function. 
# 	It depends on distribution and it is set through fracter. 
# 	Default: $dhcp::params::package_provider
#
# @param service_manage [Boolean]
# 	If you set 'false' then a service is not configurable.
# 	Default: true
#
# @param service_ensure [Optional[String]]
#	Service mode 'stopped', 'running'.
# 	Default: running
#
# @param service_enable [Boolean]
#	If 'true' service starts after system reboot.
#	Default: true
#
# @param service_name [Optional[String]]
# 	Service name is definded in params.pp function. 
# 	It depends on distribution.
# 	Default: $dhcp::params::service_name
#
# @param service_provider [Optional[String]]
#	Service provider is defined in params.pp function through facter.
#	It depends on distribution.
#	Default: $dhcp::params::service_provider
#
# @param dhcp_conf [Optional[String]] 
# 	Configuration file path definded in params.pp function. 
#	Default: $dhcp::params::dhcpd_conf
#
# @param domain_name [Optional[String]]
#	Option definitions common to all supported networks.
#	Defined in params.pp function through facter. 
#	Default: $dhcp::params::domain
#
# @param domain_name_servers [Array[String]]
#	Option definitions common to all supported networks.
#	Defined in configuration file (@param dhcp_conf)  
#	Default: [ 'ns1.example.org', 'ns2.example.org' ]
#
# @param default_lease_time [Integer]
#	DHCP IP address lease has a fixed duration, 
#	and before it expires the lease must be renewed.
#	Default: 600
#
# @param max_lease_time [Integer]
#	Specify the maximum length of time in seconds for 
#	which a client can request and hold a lease on a DHCP server. 
#	Default: 7200
#
# @param ddns_update_style [Enum['yes', 'none']]
#	Use this to enble / disable dynamic dns updates globally.
#	Default: 'none'
#
# @param authoritative [Enum['authoritative', 'none']]
#	If this DHCP server is the official DHCP server for the local
#	network, the authoritative directive should be 'authoritative'.
#	Default: 'none'
#
# @param log_facility [Optional[String]]
#	Use this to send dhcp log messages to a different log file (you also
#	have to hack syslog.conf to complete the redirection).
# 	Log-facility is definded in params.pp function. 
#	Default: $dhcp::params::log_facility
#
# @param subnet [Hash]
#	Use this to declare subnets. See example. 
#	Default: {}
#
# @param failover [Array]
#	If you want to configure DHCP server with failover option you have to 
#	configure peer option. Type primary, address, port and peer address on the first node. 
#	Type secondary, address, port and peer address on the second node.
#	Additionally you can define peer configuration inside init.pp below in parameters.  
# 	Default: [ 
#		{
#			'peer'				=> '',
#			'address'			=> "$dhcp::params::ip", 
#			'port'				=> 647,
#			'peer address'			=> '',
#			'peer port'			=> 647,
#			'max-response-delay'		=> 60,
#			'max-unacked-updates'		=> 10,
#			'mclt'				=> 3600,(if peer is primary)
#			'split'				=> 128, (if peer is primary)
#			'load balance max seconds'	=> 3
#		}
#	],
#
# @param hosts [Hash]
#	Fixed IP addresses can also be specified for hosts.   These addresses
# 	should not also be listed as being available for dynamic assignment.
# 	Hosts for which fixed IP addresses have been specified can boot using
# 	BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# 	be booted with DHCP, unless there is an address range on the subnet
# 	to which a BOOTP client is connected which has the dynamic-bootp flag
# 	set.
#	Default: {}
#
# Variables
# ----------
#
# List of variables that this module require.
#
# Examples
# --------
#
# @example install DHCP server and define domain name and damian server names
#    class { 'dhcp':
#    	domain_name		=>	'example.com',
#	domain_server_names	=>	[ 'ns1.example.com', 'ns2.example.com' ],
#    }
#
# @example remove DHCP server
#    class { 'dhcp':
#	package_ensure	=> absent,
#    }
#
# @example add hosts with fixed IP address
#    class { 'dhcp':
#    	hosts                  => {
#       	'alice'	=> {
#               	'hardware ethernet'     => '08:00:07:26:c0:a5',
#                	'fixed-address'         => '192.168.23.12'
#                },
#                'john'	=> {
#                	'hardware ethernet'     => '08:00:07:26:c0:a6',
#                	'fixed-address'         => '192.168.23.11'
#                }
#       },
#    }
#
# @example add simple subnet
#    class { 'dhcp':
#	subnet                  => {
#                        '10.10.10.0 netmask 255.255.255.0'      => {
#                                'range'                         => '10.10.10.5 10.10.10.10',
#                                'option routers'                => '10.10.10.1',
#                                'option broadcast-address'      => '10.10.10.255'
#                        }
#       },
#    }
#
# @example add peer failover
# node 'node1' {
#    class { 'dhcp':
#	failover	=> [
#		{
#			'peer'		=> 'primary',
#                       'peer address'  => '10.10.10.11'
#		}
#	],
#    }
# }
# node 'nede2' {
#    class { 'dhcp':
#	failover	=> [
#		{
#			'peer'		=> 'secondary',
#                       'peer address'  => '10.10.10.12'
#		}
#	],
#    }
# }
#
# Authors
# -------
#
# Krzysztof Szymczak k.szymczak@unixy.pl
#
# Copyright
# ---------
#
# Copyright 2017 intelligsystems, Apache-2.0 licence.
#
class dhcp (
	Boolean $package_manage			= true,
	Optional[String] $package_ensure	= 'present',
	Optional[String] $package_name 		= $dhcp::params::package_name,
	Optional[String] $package_provider	= $dhcp::params::package_provider,
	Boolean $service_manage			= true,
	Optional[String] $service_ensure	= 'running',
	Boolean $service_enable			= true,
	Optional[String] $service_name 		= $dhcp::params::service_name,
	Optional[String] $service_provider	= $dhcp::params::service_provider,
	Optional[String] $dhcpd_conf		= $dhcp::params::dhcpd_conf,
	Optional[String] $domain_name		= $dhcp::params::domain,
	Array[String] $domain_name_servers	= [ 'ns1.example.org', 'ns2.example.org' ],
	Integer $default_lease_time		= 600,
	Integer $max_lease_time			= 7200,
	Enum['yes', 'none'] $ddns_update_style	= 'none',
	Enum['authoritative', 'none'] $authoritative = 'authoritative',
	Optional[String] $log_facility		= $dhcp::params::log_facility,
	Hash $subnet				= {},
	Array $failover				= [ 
		{
			'peer'				=> '',
			'address'			=> "$dhcp::params::ip", 
			'port'				=> 647,
			'peer address'			=> '',
			'peer port'			=> 647,
			'max-response-delay'		=> 60,
			'max-unacked-updates'		=> 10,
			'mclt'				=> 3600,
			'split'				=> 128,
			'load balance max seconds'	=> 3
		}
	],
	Hash $hosts				= {}
) inherits dhcp::params {
	contain dhcp::install
	contain dhcp::config
	contain dhcp::service
}
