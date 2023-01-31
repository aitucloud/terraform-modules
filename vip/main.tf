
resource "openstack_networking_port_v2" "vip_port" {
  name               = "${var.name}_vip"
  network_id         = var.env_vars.network_ids[var.subnet]
  admin_state_up     = true
  no_security_groups = true
  fixed_ip {
    subnet_id = var.env_vars.subnet_ids[var.subnet]
  }
}

data "openstack_networking_subnet_v2" "floating_ip_subnet" {
  count = var.floating_ip ? 1 : 0
  name  = var.ext_net
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count     = var.floating_ip ? 1 : 0
  pool      = var.ext_net
  subnet_id = data.openstack_networking_subnet_v2.floating_ip_subnet[count.index].id
  port_id   = openstack_networking_port_v2.vip_port.id
}
