# terraform-openstack-serules


Terraform module to create rules for segroups on OpenStack.  
**Depends on module.segroups**  
The module creates **only security group rules**. Security groups are created in the parent module for security groups - segroups!  

## Inputs
| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|env_vars  | Environment variables for integration with segroups module | object | - | **yes** |
|secgroups.key(sg)  | ID of the security group | any | `-` | **yes** |
|secgroups.value(rules)  | List of the security group rules | list(object) | `[]` | **yes** |
|secgroups.value.direction  | The direction of the rule, valid values are `ingress` or `egress` | string | `-` | **yes** |
|secgroups.value.ethertype  | The layer 3 protocol type, valid values are `IPv4` or `IPv6` | string | - | **yes**  |
|secgroups.value.protocol  | The layer 4 protocol type | string | - | no |
|secgroups.value.port_range_min  | The lower part of the allowed port range, valid integer value needs to be between 1 and 65535 | number | - | no |
|secgroups.value.port_range_max  | The higher part of the allowed port range, valid integer value needs to be between 1 and 65535 | number | - | no |
|secgroups.value.remote_ip_prefix  | The remote CIDR, the value needs to be a valid CIDR (i.e. 192.168.0.0/16) | string | - | no |

## Usage examples
```hcl
locals {
  secgroups = {
    net = [
      { direction        = "egress"
        ethertype        = "IPv4"
      }
    ]
    ssh = [
      { direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 22
        port_range_max   = 22
        remote_ip_prefix = "0.0.0.0/0"
      }
    ]
    https = [
      { direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 80
        port_range_max   = 80
        remote_ip_prefix = "0.0.0.0/0"
      },
      { direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 443
        port_range_max   = 443
        remote_ip_prefix = "0.0.0.0/0"
      }
    ]
}

module "rules" {
  env_vars = local.env_vars
  for_each = local.secgroups
  rules    = each.value
  sg       = each.key
  source   = "git::https://github.com/aitucloud/terraform-modules.git//serules?ref=master"
}
```
