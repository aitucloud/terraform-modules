resource "openstack_networking_port_v2" "extra_port" {
  for_each       = var.ifaces
  name           = "${var.name}_port_${each.key}"
  network_id     = var.env_vars.network_ids[each.value.subnet]
  admin_state_up = true

  security_group_ids = [for sg in each.value.secgroups : var.env_vars.secgroups[sg]]
  fixed_ip {
    subnet_id = var.env_vars.subnet_ids[each.value.subnet]
  }
}

resource "openstack_compute_interface_attach_v2" "extra_port" {
  for_each    = var.ifaces
  instance_id = openstack_compute_instance_v2.instance.id
  port_id     = openstack_networking_port_v2.extra_port[each.key].id
}
