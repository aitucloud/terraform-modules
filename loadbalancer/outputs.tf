output "loadbalancer_vip_port_id" {
  description = "The Port ID of the Load Balancer IP"
  value       = openstack_lb_loadbalancer_v2.loadbalancer.vip_port_id
}
