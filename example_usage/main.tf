provider "openstack" {
  auth_url         = "$https://keystone:5000/v3/"
  tenant_name      = "$mytenant"
  user_domain_name = "$myuserdomainname"
  cacert_file      = file("${path.module}/ca.crt")
  max_retries      = 5
  domain_name      = "$mydomainname"
}

data "openstack_images_image_v2" "almalinux_9" {
  name = "AlmaLinux-9"
}

data "openstack_images_image_v2" "almalinux_8" {
  name = "AlmaLinux-8"
}

data "openstack_images_image_v2" "centos_8" {
  name = "CentOS-Stream-8"
}

data "openstack_images_image_v2" "centos_7" {
  name = "CentOS-7"
}

locals {
  env_vars = {
    network_ids = module.net.networks
    subnet_ids  = module.net.subnets
    secgroups   = module.secgroup.secgroups
  }

  subnets = {
    jumphost = "172.16.10.0/24"
    app      = "172.16.11.0/24"
    db       = "172.16.12.0/24"
  }

  secgroups = {
    ssh = [
      { direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "tcp"
        port_range_min   = 22
        port_range_max   = 22
        remote_ip_prefix = "0.0.0.0/0"
      }
    ]
    icmp = [
      { direction        = "ingress"
        ethertype        = "IPv4"
        protocol         = "icmp"
        port_range_min   = 0
        port_range_max   = 0
        remote_ip_prefix = "0.0.0.0/0"
      }
    ]
  }
}
