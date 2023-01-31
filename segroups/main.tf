resource "openstack_networking_secgroup_v2" "segroup" {
  for_each             = var.secgroups
  name                 = each.key
  delete_default_rules = true
}
