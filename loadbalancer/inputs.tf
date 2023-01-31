variable "env_vars" {
  description = "Variables that were created in network module"
  type = object({
    network_ids = map(string)
    subnet_ids  = map(string)
    secgroups   = map(string)
  })
}

variable "floating_ip" {
  description = "Boolean who allow you to to make floating_ip or not for your Loadbalancer"
  type        = bool
  default     = false
}

variable "ext_net" {
  description = "FIP net"
  default     = null
}

variable "name" {
  description = "Name to prefix all resources created on OpenStack"
  type        = string
}

variable "lb_description" {
  description = "Human-readable description for the Loadbalancer"
  type        = string
  default     = null
}

variable "subnet" {
  description = "The network on which to allocate the Loadbalancer's address"
  type        = string
}

variable "listener_protocol" {
  description = "The protocol - can either be TCP, HTTP, HTTPS or TERMINATED_HTTPS"
  type        = string
  default     = "HTTP"
}

variable "listener_protocol_port" {
  description = "The port on which to listen for client traffic"
  type        = number
  default     = 80
}

variable "listener_connection_limit" {
  description = "The maximum number of connections allowed for the Listener"
  type        = number
  default     = -1
}

variable "lb_pool_method" {
  description = "The load balancing algorithm to distribute traffic to the pool's members. Must be one of ROUND_ROBIN, LEAST_CONNECTIONS, or SOURCE_IP"
  type        = string
  default     = "ROUND_ROBIN"
}

variable "lb_pool_protocol" {
  description = "The protocol - can either be TCP, HTTP, HTTPS or PROXY"
  type        = string
  default     = "HTTP"
}

variable "monitor_url_path" {
  description = "Required for HTTP(S) types. URI path that will be accessed if monitor type is HTTP or HTTPS"
  type        = string
  default     = "/"
}

variable "monitor_expected_codes" {
  description = "Required for HTTP(S) types. Expected HTTP codes for a passing HTTP(S) monitor. You can either specify a single status like 200, or a range like 200-202"
  type        = string
  default     = "200"
}

variable "monitor_delay" {
  description = "The time, in seconds, between sending probes to members"
  type        = number
  default     = 20
}

variable "monitor_timeout" {
  description = "Maximum number of seconds for a monitor to wait for a ping reply before it times out"
  type        = number
  default     = 10
}

variable "monitor_max_retries" {
  description = "Number of permissible ping failures before changing the member's status to INACTIVE. Must be a number between 1 and 10"
  type        = number
  default     = 5
}

variable "members" {
  description = "The IP addresses/ports of the members to receive traffic from the load balancer"
  type = map(object({
    ip              = string
    port            = string
    monitor_port    = optional(number)
    monitor_address = optional(string)
    weight          = optional(number)
    backup          = optional(bool)
    subnet_id       = optional(string)
  }))
  default = {}
}

variable "certificate" {
  description = "The certificate data to be stored. (file_name)"
  type        = string
  default     = ""
}

variable "private_key" {
  description = "The private key data to be stored. (file_name)"
  type        = string
  default     = ""
}

variable "certificate_intermediate" {
  description = "The intermediate certificate data to be stored. (file_name)"
  type        = string
  default     = ""
}
