variable "router_id" {
  description = "ID of the router to which all created subnets will be connected"
  type        = string
}

variable "subnets" {
  description = "Self-service network inside the project"
  type        = map(any)
}

variable "dns_ips" {
  description = "Full list of dns servers in datacenter"
  type        = list(any)
  default = [
    "8.8.8.8",
    "1.1.1.1"
  ]
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = set(string)
  default     = []
}
