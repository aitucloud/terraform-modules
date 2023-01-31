data "openstack_networking_network_v2" "mynetwrokname" {
  name = "mynetwrokname"
}

data "openstack_networking_subnet_v2" "mynetwrokname" {
  name = "mynetwrokname"
}

resource "openstack_networking_router_v2" "test_router" {
  name                = "test_router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.mynetwrokname.id
  external_fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.mynetwrokname.id
  }
}

module "net" {
  source    = "git::https://github.com/aitucloud/terraform-modules.git//network?ref=master"
  router_id = openstack_networking_router_v2.test_router.id
  subnets   = local.subnets
}

module "secgroup" {
  source     = "git::https://github.com/aitucloud/terraform-modules.git//segroups?ref=master"
  secgroups   = local.secgroups
}

module "rules" {
  env_vars = local.env_vars
  for_each = local.secgroups
  rules    = each.value
  sg       = each.key
  source   = "git::https://github.com/aitucloud/terraform-modules.git//serules?ref=master"
}
