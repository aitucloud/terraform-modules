# terraform-openstack-network
![Terraform Build](https://nexus.btsd.kz/repository/devops/badge.svg)

Terraform module to create networks on OpenStack.

## Inputs

| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|router_id  | ID of the router to which all created subnets will be connected | string | - | **yes** |
|subnets  | Self-service network that will be created by the module in project | map | - | **yes** |

## Outputs

| Name | Description |
|:-----|:------------|
| networks | Created network IDs |
| subnets | Created subnet IDs |

## Usage example


```hcl
locals {

  subnets = {
    jumphost = "172.16.10.0/24"
    app      = "172.16.11.0/24"
    db       = "172.16.12.0/24"
  }
}

data "openstack_networking_network_v2" "myextnet" {
  name = "myextnet"
}

data "openstack_networking_subnet_v2" "myextnet" {
  name = "myextnet"
}

resource "openstack_networking_router_v2" "test_router" {
  name                = "test_router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.myextnet.id
  external_fixed_ip {
    subnet_id = data.openstack_networking_subnet_v2.myextnet.id
  }
}

module "net" {
  source = "git::https://github.com/aitucloud/terraform-modules.git//network?ref=master"
  router_id = openstack_networking_router_v2.test_router.id
  subnets   = local.subnets
}
```
