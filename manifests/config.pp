# Configuration class
class dhcp::config inherits dhcp {
  file { $dhcp::dhcpd_conf:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template('dhcp/dhcpd_conf.erb'),
    notify  => Service[$dhcp::service_name],
  }
}
