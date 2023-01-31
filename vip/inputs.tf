variable "env_vars" {
  description = "Variables that were created in network module"
  type = object({
    network_ids = map(string)
    subnet_ids  = map(string)
    secgroups   = map(string)
  })
}

variable "name" {
  description = "Port name"
  type        = string
}

variable "subnet" {
  description = "Subnet name specified in network module"
  type        = string
}

variable "floating_ip" {
  description = "Boolean who allow you to to make floating_ip or not for your port"
  type        = bool
  default     = false
}

variable "ext_net" {
  description = "FIP net"
  default     = null
}
