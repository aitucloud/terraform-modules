data "openstack_networking_subnet_v2" "floating_ip_subnet" {
  count = var.floating_ip ? 1 : 0
  name  = var.ext_net
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  count     = var.floating_ip ? 1 : 0
  pool      = var.ext_net
  subnet_id = data.openstack_networking_subnet_v2.floating_ip_subnet[count.index].id
  port_id   = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}
