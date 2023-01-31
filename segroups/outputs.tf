output "secgroups" {
  value = { for k, v in openstack_networking_secgroup_v2.segroup : k => v.id }
}
