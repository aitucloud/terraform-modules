data "openstack_networking_subnet_v2" "floating_ip_subnet" {
  count = var.floating_ip ? 1 : 0
  name  = var.ext_net
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count     = var.floating_ip ? 1 : 0
  pool      = var.ext_net
  subnet_id = data.openstack_networking_subnet_v2.floating_ip_subnet[count.index].id
  port_id   = openstack_networking_port_v2.port.id
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip" {
  count       = var.floating_ip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.floating_ip[count.index].address
  instance_id = openstack_compute_instance_v2.instance.id
}
