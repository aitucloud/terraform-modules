# terraform-openstack-server


Terraform module to create servers on OpenStack.  
**Depends on:**
 - **module.network**  
 - **module.segroups** 

## Inputs
| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|env_vars  | Environment variables for integration with other modules | object(map) | - | **yes** |
|name  | Instance unique name | string | - | **yes** |
|hostname  | Explicitly set hostname/fqdn | string | - | **yes** |
|subnet  | Subnet name specified in network module | string | - | **yes** |
|secgroups  | An array of one or more security group names to associate with the server, specified in segroup module | list | `[]` | no |
|disk_size  | Instance root disk size, GB | number | `30` | no |
|image_id  | Instance root disk image  | string | `-` | **yes** |
|flavor  | Instance flavor | string | `-` | **yes** |
|volume_type  | `volume_type` for instance root disk  | string |  `standard` | no |
|volumes  | Instance nonroot disks | map(any) | `{}` | no |
|floating_ip  | Boolean who allow you to to make floating_ip or not for your instance | bool | `false` | no |
|ext_net  | Required if `floating_ip is true`. FIP net name  | string |`null` | no |
|ifaces  | Additional ifaces for instance | map(any) | `-` | no |
|vips  | Instance virtual addresses(allowed_address_pairs) | list(any) | `[]` | no |

## Outputs
| Name | Description |
|:-----|:------------|
| instance_id | Created instance id |
| port_id | Created instance port id |

## Notes
`ifaces` = creates additional ports (interfaces) and attaches to the instance.  
**Important:** you will have 2 default routes and this needs to be fixed.  
```hcl
ifaces = {
  k8s = { subnet = "db", secgroups = ["ssh", "net"] }
}
```
`vips` = a list of addresses created by the vip module that are allowed to bind (allowed_address_pairs) to the instance port.  
```hcl
# 1 vip example
vips = module.vip_1.vip_port_address
# 2 vip example
vips = concat(module.vip_1.vip_port_address,module.vip_2.vip_port_address)
```

## Usage example

Create a basic instance:
```hcl
module "vm_0" {
  env_vars    = local.env_vars
  name        = "f2"
  hostname    = "f2.demo"
  subnet      = "jumphost"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=master"
  secgroups   = ["ssh", "ldap"]
  flavor      = "b1.xsmall"
  volume_type = "fast"
  image_id    = data.openstack_images_image_v2.almalinux_9.id
}
```
Create a instance with additional volumes:
```hcl
module "vm_0" {
  env_vars   = local.env_vars
  name       = "f2"
  hostname   = "f2.demo"
  subnet     = "jumphost"
  source     = "git::https://github.com/aitucloud/terraform-modules.git//server?ref=master"
  secgroups  = ["ssh", "ldap", "net"]
  volume_type = "fast"
  volumes = {
    data  = { size = 100, type = "fast" }
    data2 = { size = 50, type = "standard" }
  }
}
```
Create a 2 instances with 1 vip/fip for a fault-tolerant setup on vrrp:
```hcl
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
```
