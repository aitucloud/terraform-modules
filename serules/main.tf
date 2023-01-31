resource "openstack_networking_secgroup_rule_v2" "rule" {
  count             = length(var.rules)
  direction         = var.rules[count.index].direction
  ethertype         = var.rules[count.index].ethertype
  protocol          = var.rules[count.index].protocol
  port_range_min    = var.rules[count.index].port_range_min
  port_range_max    = var.rules[count.index].port_range_max
  remote_ip_prefix  = var.rules[count.index].remote_ip_prefix
  security_group_id = var.env_vars.secgroups[var.sg]
}
