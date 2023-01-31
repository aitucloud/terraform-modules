output "networks" {
  value = { for k, v in openstack_networking_network_v2.network : k => v.id }
}

output "subnets" {
  value = { for k, v in openstack_networking_subnet_v2.subnet : k => v.id }
}
