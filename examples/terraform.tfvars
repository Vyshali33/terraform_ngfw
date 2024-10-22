name                                      = "vpc-test"
project_id                                = "sunny-sunbeam-435423-i2"
description                               = "global vpc network for test"
auto_create_subnetworks                   = false
routing_mode                              = "GLOBAL"
mtu                                       = 1460
enable_ula_internal_ipv6                  = false
internal_ipv6_range                       = "10.0.0.0/24"
network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"
delete_default_routes_on_create           = false