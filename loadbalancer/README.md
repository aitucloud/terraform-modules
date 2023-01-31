# terraform-openstack-loadbalancer
Based on https://github.com/thobiast/terraform-openstack-loadbalancer  



Terraform module to create Load Balancer on OpenStack.

## Inputs

| Name | Description | Type | Default | Required |
|:-----|:------------|:----:|:-------:|:--------:|
|env_vars  | Environment variables for integration with other modules | object | - | **yes** |
|floating_ip  | Create floating_ip for the balancer | bool | `-` | no |
|name  | Name to prefix all resources created on OpenStack | string | - | **yes** |
|lb_description  | Human-readable description for the Loadbalancer | string | `-` | no |
|subnet  | The network on which to allocate the Loadbalancer's address. Converted to the network_id that is created in the network module | string | - | **yes** |
|listener_protocol  | The protocol - can either be TCP, HTTP, HTTPS or TERMINATED_HTTPS | string | `HTTP` | no |
|listener_protocol_port  | The port on which to listen for client traffic | string | `80` | no |
|listener_connection_limit  | The maximum number of connections allowed for the Listener | string | `-1` | no |
|lb_pool_method  | The load balancing algorithm to distribute traffic to the pool's members. Must be one of ROUND_ROBIN, LEAST_CONNECTIONS, or SOURCE_IP | string | `ROUND_ROBIN` | no |
|lb_pool_protocol  | The protocol - can either be TCP, HTTP, HTTPS or PROXY | string | `HTTP` | no |
|monitor_url_path  | Required for HTTP(S) types. URI path that will be accessed if monitor type is HTTP or HTTPS | string | `/` | no |
|monitor_expected_codes  | Required for HTTP(S) types. Expected HTTP codes for a passing HTTP(S) monitor. You can either specify a single status like 200, or a range like 200-202 | string | `200` | no |
|monitor_delay  | The time, in seconds, between sending probes to members | string | `20` | no |
|monitor_timeout  | Maximum number of seconds for a monitor to wait for a ping reply before it times out | string | `10` | no |
|monitor_max_retries  | Number of permissible ping failures before changing the member's status to INACTIVE. Must be a number between 1 and 10 | string | `5` | no |
|members  | The IP addresses/ports of the members to receive traffic from the load balancer | map(object) | - | **yes** |
|member.ip  | Member IP addresses | string | - | **yes** |
|member.port  | Member port | number | - | **yes** |
|member.weight  | A positive integer value that indicates the relative portion of traffic that this members should receive from the pool. For example, a member with a weight of 10 receives five times as much traffic as a member with a weight of 2 | number | 1 | no |
|member.backup  | A bool that indicates whether the member is backup | bool | false | no |
|member.monitor_port  | An alternate protocol port used for health monitoring a backend member | number | null | no |
|member.monitor_address  | An alternate ip used for health monitoring a backend member | string | null | no |
|certificate  | The certificate data to be stored. (file_name) | string | `-` | no |
|private_key  | The private key data to be stored. (file_name) | string | `-` | no |
|certificate_intermediate  | The intermediate certificate data to be stored. (file_name) | string | `-` | no |

## Outputs

| Name | Description |
|:-----|:------------|
| loadbalancer_vip_port_id | The Port ID of the Load Balancer IP |

## Usage example

Create a http load balancer:

```hcl
module "lb" {
  env_vars          = local.env_vars
  source            = "git::https://github.com/aitucloud/terraform-modules.git//loadbalancer?ref=master"
  name              = "test-http"
  subnet            = var.public_subnet_id
  members           = {
    db_1 = { ip = "172.16.11.112", port = 80 }
    db_2 = { ip = "172.16.11.202", port = 80 }
  }
}
```

Create a http load balancer with floating_ip:

```hcl
module "lb" {
  env_vars          = local.env_vars
  source            = "git::https://github.com/aitucloud/terraform-modules.git//loadbalancer?ref=master"
  name              = "test-http"
  subnet            = var.public_subnet_id
  floating_ip       = true
  ext_net           = "qshyosdemodevtenant"
  members           = {
    db_1 = { ip = "172.16.11.112", port = 80 }
    db_2 = { ip = "172.16.11.202", port = 80 }
  }
}
```

Create a https balance with floating_ip and certificate stored on the load balancer:

```hcl
module "lb" {
  env_vars               = local.env_vars
  source                 = "git::https://github.com/aitucloud/terraform-modules.git//loadbalancer?ref=dev"
  name                   = "test-http"
  subnet                 = "lb"
  floating_ip            = true
  ext_net                = "qshyosdemodevtenant"

  listener_protocol      = "TERMINATED_HTTPS"
  listener_protocol_port = "443"
  certificate            = "lbass.pem"
  private_key            = "lbass_key.pem"

  members = {
    db_1 = { ip = "172.16.11.112", port = 80 }
    db_2 = { ip = "172.16.11.202", port = 80 }
  }
}
```
