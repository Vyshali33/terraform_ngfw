locals {
  prefix = var.policy_region == null ? var.policy_name : "${var.policy_name}-${var.policy_region}"
  global = var.policy_region == null
}

resource "google_compute_network_firewall_policy" "fw_policy" {
  count       = local.global ? 1 : 0
  name        = var.policy_name
  project     = var.project_id
  description = var.description
}

resource "google_compute_network_firewall_policy_association" "vpc_associations" {
  for_each          = local.global && length(var.target_vpcs) > 0 ? { for x in var.target_vpcs : base64encode(x) => x } : {}
  name              = "${local.prefix}-${element(split("/", each.value), length(split("/", each.value)) - 1)}"
  attachment_target = each.value
  firewall_policy   = google_compute_network_firewall_policy.fw_policy[0].name
  project           = var.project_id
}

resource "google_compute_network_firewall_policy_rule" "rules" {

  for_each                = local.global ? { for x in var.rules : x.priority => x } : {}
  priority                = each.key
  project                 = var.project_id
  action                  = each.value.action
  description             = each.value.description
  direction               = each.value.direction
  disabled                = each.value.disabled
  enable_logging          = each.value.enable_logging
  firewall_policy         = google_compute_network_firewall_policy.fw_policy[0].name
  rule_name               = each.value.rule_name
  target_service_accounts = each.value.target_service_accounts
  tls_inspect             = each.value.tls_inspect

  dynamic "security_profile_group" {
    for_each = each.value.action=="apply_security_profile_group" && each.value.match.security_profile_group !=null ? [each.value.match.security_profile_group] : []
    content {
      name = security_profile_group.value
    }
    
  }

  dynamic "target_secure_tags" {
    for_each = each.value.target_service_accounts != null || each.value.target_secure_tags == null ? [] : toset(each.value.target_secure_tags)
    content {
      name = target_secure_tags.value
    }
  }

  match {
    src_ip_ranges             = lookup(each.value.match, "src_ip_ranges", [])
    src_fqdns                 = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_fqdns", []) : []
    src_region_codes          = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_region_codes", []) : []
    src_threat_intelligences  = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_threat_intelligences", []) : []
    src_address_groups        = each.value.direction == "INGRESS" ? lookup(each.value.match, "src_address_groups", []) : []
    dest_ip_ranges            = lookup(each.value.match, "dest_ip_ranges", []) 
    dest_fqdns                = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_fqdns", []) : []
    dest_region_codes         = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_region_codes", []) : []
    dest_threat_intelligences = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_threat_intelligences", []) : []
    dest_address_groups       = each.value.direction == "EGRESS" ? lookup(each.value.match, "dest_address_groups", []) : []

    dynamic "src_secure_tags" {
      for_each = each.value.direction != "INGRESS" || each.value.match.src_secure_tags == null ? [] : toset(each.value.match.src_secure_tags)
      content {
        name = src_secure_tags.value
      }
    }

    dynamic "layer4_configs" {
      for_each = each.value.match.layer4_configs
      content {
        ip_protocol = layer4_configs.value.ip_protocol
        ports       = layer4_configs.value.ports
      }
    }

  }

}
