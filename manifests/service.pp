# Service manage
class dhcp::service inherits dhcp {
	if ! ($dhcp::service_ensure in [ 'running', 'stopped' ]) {
    		fail('service_ensure parameter must be running or stopped')
  	}
	if $dhcp::service_manage == true {
    		service { 'dhcp':
      			name		=> $dhcp::service_name,
      			ensure		=> $dhcp::service_ensure,
      			enable		=> $dhcp::service_enable,
			hasrestart	=> true,
      			provider	=> $dhcp::service_provider,
			require 	=> [
    				Package[$dhcp::package_name],
    				File[$dhcp::dhcp_conf],
  			],
    		}
  	}
}
