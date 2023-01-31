# terraform-openstack-segroups
![Terraform Build](https://nexus.btsd.kz/repository/devops/badge.svg)

Terraform module to create segroups on OpenStack.  
The module creates **only security groups**. Rules for them are created in the submodule - serules!  

## Inputs
| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|delete_default_rules  | Delete default security group rules | bool | true | no |
|secgroups  | Map that contains group rules | map | - | **yes** |
|secgroups.keys  | Name of the security group | key | - | **yes** |
|secgroups.values  | List of the security group rules | list(object) | `[]` | **yes** |

## Outputs
| Name | Description |
|:-----|:------------|
| secgroups | Created security group IDs |


## Usage examples
```hcl
locals {
  secgroups = {
    ssh = [{rule1},{rule2}]
    net = [{ruleN}]
  }
}

module "secgroup" {
  source = "git::https://github.com/aitucloud/terraform-modules.git//segroups?ref=master"
  secgroups = local.secgroups
}
```
