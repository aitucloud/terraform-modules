resource "openstack_networking_port_v2" "port" {
  name           = "${var.name}_port"
  network_id     = var.env_vars.network_ids[var.subnet]
  admin_state_up = true

  security_group_ids = [for sg in var.secgroups : var.env_vars.secgroups[sg]]
  fixed_ip {
    subnet_id = var.env_vars.subnet_ids[var.subnet]
  }
  dynamic "allowed_address_pairs" {
    for_each = var.vips
    content {
      ip_address = allowed_address_pairs.value
    }
  }
}

resource "openstack_blockstorage_volume_v3" "system" {
  name                 = "${var.name}_system"
  description          = "system volume"
  image_id             = var.image_id
  enable_online_resize = true
  size                 = 30
  volume_type          = var.volume_type
}

resource "openstack_compute_instance_v2" "instance" {
  name         = var.name
  flavor_name  = var.flavor
  config_drive = false

  user_data = <<-EOT
  #cloud-config
  hostname: ${var.hostname}
  fqdn: ${var.hostname}
  EOT

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.system.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  network {
    port = openstack_networking_port_v2.port.id
  }
}
