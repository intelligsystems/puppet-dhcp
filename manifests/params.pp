# Class params inherited by init
class dhcp::params {
  $package_provider = $facts['package_provider']
  $service_provider = $facts['service_provider']
  $dhcpd_conf       = '/etc/dhcp/dhcpd.conf'
  $log_facility     = 'local7'
  $ip               = $facts['ipaddress']
  $domain           = $facts['domain']
  case $facts['osfamily'] {
    # Debian 8.8|Ubuntu 17.04
    'Debian': {
      $package_name      = 'isc-dhcp-server'
      $package_name_ldap = 'isc-dhcp-server-ldap'
      $service_name      = 'isc-dhcp-server'
    }
    # CentOS 7
    'RedHat': {
      $package_name = 'dhcp'
      $service_name = 'dhcpd'
    }
    # Debian
    default: {
      $package_name = 'isc-dhcp-server'
    }
  }
}
