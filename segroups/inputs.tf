variable "delete_default_rules" {
  type        = bool
  description = "Delete default security group rules"
  default     = true
}

variable "secgroups" {
  type = map(list(object({
    direction        = string
    ethertype        = string
    protocol         = optional(string)
    port_range_min   = optional(number)
    port_range_max   = optional(number)
    remote_ip_prefix = optional(string)
  })))
  default = {}
}
