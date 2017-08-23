# Simple subnet example with failover option between two nodes.
# It will generate config in node2.example.org
#
# dhcpd.conf: Managed by puppet. 
# Do not change it manually!
#
# Template from CentOS 7
#
# Option definitions common to all supported networks...
#option domain-name "local";
#option domain-name-servers 192.168.50.249, 192.168.50.250;
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
# Peer section.
#failover peer "dhcp-failover" {
#secondary;
#address 192.168.50.243;
#port 647;
#peer address 192.168.50.245;
#peer port 647;
#max-response-delay 60;
#max-unacked-updates 10;
#mclt 3600;
#split 128;
#load balance max seconds 3; 
#}
#
# Subnets declaration.
#subnet 192.168.50.0 netmask 255.255.255.0 {
#pool {
#        failover peer "dhcp-failover";
#        range 192.168.50.100 192.168.50.199;
#        option routers 192.168.50.1;
#        option broadcast-address 192.168.50.255;
#}
#}
#
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
