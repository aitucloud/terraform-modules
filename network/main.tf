resource "openstack_networking_network_v2" "network" {
  for_each       = var.subnets
  name           = "${each.key}_network"
  admin_state_up = "true"
  tags           = var.tags
}

resource "openstack_networking_subnet_v2" "subnet" {
  for_each        = var.subnets
  name            = "${each.key}_subnet"
  network_id      = openstack_networking_network_v2.network[each.key].id
  cidr            = each.value
  ip_version      = 4
  enable_dhcp     = true
  dns_nameservers = var.dns_ips
  allocation_pool {
    start = cidrhost(each.value, 10)
    end   = cidrhost(each.value, 250)
  }
  tags = var.tags
}

resource "openstack_networking_router_interface_v2" "router_iface" {
  for_each  = var.subnets
  router_id = var.router_id
  subnet_id = openstack_networking_subnet_v2.subnet[each.key].id
}
