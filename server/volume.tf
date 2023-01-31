resource "openstack_blockstorage_volume_v3" "data" {
  for_each    = var.volumes
  name        = "${var.name}_${each.key}"
  size        = each.value.size
  volume_type = each.value.type
}

resource "openstack_compute_volume_attach_v2" "data" {
  for_each    = var.volumes
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.data[each.key].id
}
