## basic instance
module "vm_0" {
  env_vars   = local.env_vars
  name       = "vm0"
  hostname   = "vm0.demo"
  subnet     = "jumphost"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=master"
  secgroups  = ["ssh", "icmp"]
}

## instance with fip
module "vm_1" {
  env_vars    = local.env_vars
  name        = "vm1"
  hostname    = "vm1.demo"
  subnet      = "app"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=dev"
  secgroups   = ["ssh", "net", "web"]
  flavor      = "b1.xsmall"
  image_id    = data.openstack_images_image_v2.almalinux_9.id
  floating_ip = true
  ext_net     = "qshyosdemodevtenant"
}

## instance with additional volumes
module "vm_1" {
  env_vars   = local.env_vars
  name       = "f3"
  hostname   = "f3.demo"
  subnet     = "app"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=dev"
  secgroups  = ["ssh", "net", "web"]
  flavor     = "b1.xsmall"
  image_id   = data.openstack_images_image_v2.almalinux_9.id
  volumes = {
    data0 = { size = 100, type = "fast" }
    data1 = { size = 50, type = "fast" }
  }
}

## vip+fip and 2 instances with allowed-address-pairs for use vip
module "vip_lb_0" {
  env_vars    = local.env_vars
  name        = "vip_lb_0"
  subnet      = "lb"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//vip?ref=dev"
  floating_ip = true
  ext_net     = "qshyosdemodevtenant"
}
module "lb_0" {
  env_vars   = local.env_vars
  name       = "lb0"
  hostname   = "lb0.demo"
  subnet     = "lb"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=master"
  secgroups  = ["ssh", "ldap", "vrrp"]
  vips       = module.vip_lb_0.vip_port_address
}
module "lb_1" {
  env_vars   = local.env_vars
  name       = "lb1"
  hostname   = "lb1.demo"
  subnet     = "lb"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=master"
  secgroups  = ["ssh", "ldap", "vrrp"]
  vips       = module.vip_lb_0.vip_port_address
}
