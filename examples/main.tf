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



variable "tags" {
  type = list(object({
    key_name        = string
    key_description = string
    purpose         = string
    purpose_data    = map(string)
    values          = list(object({
      value_name        = string
      value_description = optional(string, "")
    }))
  }))
}

# Create google_tag_key for each tag in the list
resource "google_tag_key" "tag_keys" {
  for_each      = { for tag in var.tags : tag.key_name => tag }
  short_name    = each.value.key_name
  description   = each.value.key_description
  parent        = "organizations/1234567890" # Replace with actual organization/folder ID
}

# Create google_tag_value for each entry in values list for each tag key
resource "google_tag_value" "values" {
  for_each = { 
    for tag in var.tags : tag.key_name => {
      key_id   = google_tag_key.tag_keys[tag.key_name].id
      values   = [for v in tag.values : {
        value_name        = v.value_name
        value_description = v.value_description
      }]
    }
  }

  # Creating each value as a unique resource by looping over the values list
  for_each = { for i, v in each.value.values : "${each.key}-${i}" => {
    short_name  = v.value_name
    description = v.value_description
    parent      = each.value.key_id
  }}

  short_name  = each.value.short_name
  description = each.value.description
  parent      = each.value.parent
}variable "tags" {
  type = list(object({
    key_name        = string
    key_description = string
    purpose         = string
    purpose_data    = map(string)
    values          = list(object({
      value_name        = string
      value_description = optional(string, "")
    }))
  }))
}

# Create google_tag_key for each tag in the list
resource "google_tag_key" "tag_keys" {
  for_each      = { for tag in var.tags : tag.key_name => tag }
  short_name    = each.value.key_name
  description   = each.value.key_description
  parent        = "organizations/1234567890" # Replace with actual organization/folder ID
}

# Flatten the tags and values list into a single map for google_tag_value
locals {
  flattened_values = {
    for tag in var.tags : tag.key_name => {
      tag_key_id = google_tag_key.tag_keys[tag.key_name].id
      values     = [
        for v in tag.values : {
          value_name        = v.value_name
          value_description = try(v.value_description, "")
        }
      ]
    }
  }
}

# Create google_tag_value resources for each unique tag and value
resource "google_tag_value" "values" {
  for_each = { for tag_key, tag_data in local.flattened_values : 
    "${tag_key}-${tag_data.values[*].value_name}" => {
      tag_key_id = tag_data.tag_key_id
      values     = tag_data.values
    }
  }

  short_name  = each.value.values.value_name
  description = each.value.valuesvariable "tags" {
  type = list(object({
    key_name        = string
    key_description = string
    purpose         = string
    purpose_data    = map(string)
    values          = list(object({
      value_name        = string
      value_description = optional(string, "")
    }))
  }))
}

# Create google_tag_key for each tag in the list
resource "google_tag_key" "tag_keys" {
  for_each      = { for tag in var.tags : tag.key_name => tag }
  short_name    = each.value.key_name
  description   = each.value.key_description
  parent        = "organizations/1234567890" # Replace with actual organization/folder ID
}

# Flatten the tags and values list into a single map with unique keys for each google_tag_value
locals {
  flattened_tag_values = {
    for tag in var.tags :
    for idx, value in tag.values :
    "${tag.key_name}-${value.value_name}" => {
      short_name       = value.value_name
      description      = try(value.value_description, "")
      parent           = google_tag_key.tag_keys[tag.key_name].id
    }
  }
}

# Create google_tag_value resources for each flattened value entry
resource "google_tag_value" "values" {
  for_each = local.flattened_tag_values

  short_name  = each.value.short_name
  description = each.value.description
  parent      = each.value.parent
}


