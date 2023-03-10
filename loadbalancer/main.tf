resource "openstack_lb_loadbalancer_v2" "loadbalancer" {
  name           = "${var.name}-loadbalancer"
  description    = var.lb_description
  vip_subnet_id  = var.env_vars.subnet_ids[var.subnet]
  admin_state_up = "true"
}

resource "openstack_lb_pool_v2" "lb_pool" {
  name            = "${var.name}-lb_pool"
  description     = var.lb_description
  protocol        = var.lb_pool_protocol
  lb_method       = var.lb_pool_method
  loadbalancer_id = openstack_lb_loadbalancer_v2.loadbalancer.id
}

resource "openstack_lb_listener_v2" "listener" {
  name                      = "${var.name}-listener"
  description               = var.lb_description
  protocol                  = var.listener_protocol
  protocol_port             = var.listener_protocol_port
  admin_state_up            = "true"
  connection_limit          = var.listener_connection_limit
  loadbalancer_id           = openstack_lb_loadbalancer_v2.loadbalancer.id
  default_pool_id           = openstack_lb_pool_v2.lb_pool.id
  default_tls_container_ref = var.certificate != "" ? join(",", openstack_keymanager_container_v1.tls.*.container_ref) : ""
}

### monitor has different parameters to http* and tcp
### so create the resource based on lb_pool_protocol
resource "openstack_lb_monitor_v2" "lb_monitor" {
  count          = var.lb_pool_protocol != "TCP" ? 1 : 0
  name           = "${var.name}-lb_monitor"
  pool_id        = openstack_lb_pool_v2.lb_pool.id
  type           = var.lb_pool_protocol
  url_path       = var.monitor_url_path
  expected_codes = var.monitor_expected_codes
  delay          = var.monitor_delay
  timeout        = var.monitor_timeout
  max_retries    = var.monitor_max_retries
}

resource "openstack_lb_monitor_v2" "lb_monitor_tcp" {
  count       = var.lb_pool_protocol == "TCP" ? 1 : 0
  name        = "${var.name}-lb_monitor"
  pool_id     = openstack_lb_pool_v2.lb_pool.id
  type        = var.lb_pool_protocol
  delay       = var.monitor_delay
  timeout     = var.monitor_timeout
  max_retries = var.monitor_max_retries
}

resource "openstack_lb_members_v2" "members" {
  pool_id = openstack_lb_pool_v2.lb_pool.id

  dynamic "member" {
    for_each = var.members
    content {
      address        = member.value.ip
      protocol_port  = member.value.port
      name           = "${var.name}-lb_member"
      weight         = member.value.weight
      admin_state_up = "true"
    }
  }
}

resource "openstack_keymanager_secret_v1" "certificate" {
  count                = var.certificate != "" ? 1 : 0
  name                 = "${var.name}-certificate"
  payload              = file(var.certificate)
  secret_type          = "certificate"
  payload_content_type = "text/plain"
}

resource "openstack_keymanager_secret_v1" "private_key" {
  count                = var.private_key != "" ? 1 : 0
  name                 = "${var.name}-private_key"
  payload              = file(var.private_key)
  secret_type          = "private"
  payload_content_type = "text/plain"
}

resource "openstack_keymanager_secret_v1" "intermediate" {
  count                = var.certificate_intermediate != "" ? 1 : 0
  name                 = "${var.name}-intermediate"
  payload              = file(var.certificate_intermediate)
  secret_type          = "certificate"
  payload_content_type = "text/plain"
}

resource "openstack_keymanager_container_v1" "tls" {
  count = var.certificate != "" ? 1 : 0
  name  = "${var.name}-tls"
  type  = "certificate"

  secret_refs {
    name       = "certificate"
    secret_ref = join(",", openstack_keymanager_secret_v1.certificate.*.secret_ref)
  }

  secret_refs {
    name       = "private_key"
    secret_ref = join(",", openstack_keymanager_secret_v1.private_key.*.secret_ref)
  }

  # Add intermediates if specified
  dynamic "secret_refs" {
    for_each = compact([var.certificate_intermediate])
    content {
      name       = "intermediates"
      secret_ref = join(",", openstack_keymanager_secret_v1.intermediate.*.secret_ref)
    }
  }
}
