# This example will generate DHCP configuration for two hosts only based on their MAC addresses.
# It will set static IP addresses.
#
# dhcpd.conf: Managed by puppet. 
# Do not change it manually!
#
# Template from CentOS 7
#
# Option definitions common to all supported networks...
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;
#
#default-lease-time 600;
#max-lease-time 7200;
#
# Use this to enable / disable dynamic dns updates globaly.
#ddns-update-style none;
#
# If this DHCP server is the official DHCP server for the 
# local network, the authoritative directive should be set.
#authoritative;
#
# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;
#
#
# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host alice {
#        hardware ethernet 08:00:07:26:c0:a5;
#        fixed-address 192.168.23.12;
#
#}
#host john {
#        hardware ethernet 08:00:07:26:c0:a6;
#        fixed-address 192.168.23.11;
#}
#
class { '::dhcp':
  domain_name         => 'example.org',
  domain_name_servers => [ 'ns1.example.org', 'ns2.example.org' ],
  hosts               => {
    'alice' => {
      'hardware ethernet' => '08:00:07:26:c0:a5',
      'fixed-address'     => '192.168.23.12'
    },
    'john'  => {
      'hardware ethernet' => '08:00:07:26:c0:a6',
      'fixed-address'     => '192.168.23.11'
    }
  }
}
