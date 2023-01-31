variable "name" {
  description = "Instance name"
}

variable "hostname" {
  description = "Explicitly set hostname"
}

variable "subnet" {
  description = "Subnet name specified in network module"
  type        = string
}

variable "env_vars" {
  description = "Variables that were created in network module"
  type = object({
    network_ids = map(string)
    subnet_ids  = map(string)
    secgroups   = map(string)
  })
}

variable "secgroups" {
  description = "Instance security group IDs"
  type        = list(any)
  default     = []
}

variable "disk_size" {
  description = "Instance root disk size, GB"
  type        = number
  default     = 30
}

variable "image_id" {
  type        = string
}

variable "flavor" {
  description = "Instance flavor"
  type        = string
}

variable "volume_type" {
  description = "volume_type for instance root disk"
  default     = "standard"
}

variable "volumes" {
  description = "Instance nonroot disks"
  type        = map(any)
  default     = {}
}

variable "floating_ip" {
  description = "Boolean who allow you to to make floating_ip or not for your instance"
  type        = bool
  default     = false
}

variable "ext_net" {
  description = "FIP net"
  default     = null
}

variable "ifaces" {
  description = "Additional ifaces for instance"
  type        = map(any)
  default     = {}
}

variable "vips" {
  description = "Instance virtual addresses"
  type        = list(any)
  default     = []
}
