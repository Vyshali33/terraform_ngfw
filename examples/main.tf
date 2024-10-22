module "vpc" {
  source                                    = "../modules/vpc_module"
  project_id                                = var.project_id
  name                                      = var.name
  description                               = var.description
  auto_create_subnetworks                   = var.auto_create_subnetworks
  routing_mode                              = var.routing_mode
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ula_internal_ipv6
  internal_ipv6_range                       = var.internal_ipv6_range
  network_firewall_policy_enforcement_order = var.network_firewall_policy_enforcement_order
  delete_default_routes_on_create           = var.delete_default_routes_on_create

}
module "subnet" {
  source        = "../modules/subnet_module"
  name          = var.name
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = module.vpc.vpc_name
  purpose       = var.purpose
  project_id    = var.project_id
}
module "rule" {
  source      = "../modules/ngfw_module"
  project_id  = var.project_id
  fw_name     = var.fw_name
  network     = module.vpc.vpc_name
  direction   = var.direction
  priority    = var.priority
  source_tags = var.source_tags
}
