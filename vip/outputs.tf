output "vip_port_address" {
  value = openstack_networking_port_v2.vip_port.all_fixed_ips
}
