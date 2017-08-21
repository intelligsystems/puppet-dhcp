# Install packages
class dhcp::install inherits dhcp {
  if $dhcp::package_manage == true {
    package { $dhcp::package_name:
      ensure   =>  $dhcp::package_ensure,
      provider =>  $dhcp::package_provider,
    }
  }
}
