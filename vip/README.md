# terraform-openstack-vip
![Terraform Build](https://nexus.btsd.kz/repository/devops/badge.svg)

Terraform module to create vitrual ip on OpenStack.  
**Depends on module.network**  
The module creates **only port or fip**. You can allow using the address created in this module in the server module.  

## Inputs
| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|env_vars  | Environment variables for integration with other modules | object(map) | - | **yes** |
|name  | Port name | string | - | **yes** |
|subnet  | Subnet name specified in network module | string | - | **yes** |
|floating_ip  | Boolean who allow you to to make floating_ip or not for your port | bool | `false` | no |
|ext_net  | Required if `floating_ip is true`. FIP net name  | string |`null` | no |

## Outputs
| Name | Description |
|:-----|:------------|
| vip_port_address | The address of the created port that can be allowed to connect to the instance(allowed_address_pairs) |

## Usage examples
Vip without fip:
```hcl
module "vip_nginx_1" {
  env_vars           = local.env_vars
  name               = "vip_nginx_1"
  subnet             = "lb"
  source = "git::https://github.com/aitucloud/terraform-modules.git//vip?ref=master"
}
```
Vip with fip:
```hcl
module "vip_nginx_1" {
  env_vars           = local.env_vars
  name               = "vip_nginx_1"
  subnet             = "lb"
  source = "git::https://github.com/aitucloud/terraform-modules.git//vip?ref=master"
  floating_ip=true
  ext_net = "qshyosdemodevtenant"
}
```
Allowed_address_pairs example for 1 ip:
```hcl
module "lb_0" {
  ...
  vips = module.vip_lb_0.vip_port_address
  ...
}
```
Allowed_address_pairs example for 2 ips:
```hcl
module "lb_0" {
  ...
  vips = concat(module.vip_1.vip_port_address,module.vip_2.vip_port_address)
  ...
}
```
