
resource "google_compute_network" "vpc_network" {
  project                                   = var.project_id
  name                                      = "${var.name}-vpc"
  description                               = var.description
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ula_internal_ipv6
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
  delete_default_routes_on_create           = var.delete_default_routes_on_create
}
