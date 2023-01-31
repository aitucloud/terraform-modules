variable "rules" {
  type = list(object({
    direction        = string
    ethertype        = string
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
  }))
  default = []
}

variable "sg" {
  default = null
}

variable "env_vars" {
  description = "Variables that were created in network module"
  type = object({
    secgroups = map(string)
  })
}
