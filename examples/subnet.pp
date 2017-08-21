# This example will generate simple DHCP configuration.
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
# Subnets declaration.
#subnet 10.10.10.0 netmask 255.255.255.0 {
#        range 10.10.10.5 10.10.10.10;
#        option routers 10.10.10.1;
#        option broadcast-address 10.10.10.255;
#
#}
#
class { 'dhcp':
  domain_name         => 'example.org',
  domain_name_servers => [ 'ns1.example.org', 'ns2.example.org' ],
  subnet              => {
    '10.10.10.0 netmask 255.255.255.0'  => {
      'range'                    => '10.10.10.5 10.10.10.10',
      'option routers'           => '10.10.10.1',
      'option broadcast-address' => '10.10.10.255'
    }
  },
}
