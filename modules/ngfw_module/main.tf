resource "google_compute_firewall" "rules" {
  project     = var.project_id
  name        = var.fw_name
  network     = var.network
  description = "Creates firewall rule targeting tagged instances"
  direction = var.direction
  priority = var.priority
  #source_ranges = var.direction=="INGRESS"? var.source_ranges:null

 /* dynamic "source_ranges" {
    for_each = var.direction == "INGRESS" && length(var.source_ranges) >0 ? [1] : []
    content {
      source_ranges = var.source_ranges
    }
  }

  dynamic "source_tags" {
    for_each = var.direction == "INGRESS" && length(var.source_tags) > 0 ? [1] : []
    content {
      source_tags = var.source_tags
    }
  }

  dynamic "source_service_accounts" {
    for_each = var.direction == "INGRESS" && length(var.source_service_accounts) > 0 ? [1] : []
    content {
      source_service_accounts = var.source_service_accounts
    }
  }

    dynamic "destination_ranges" {
    for_each = var.direction == "EGRESS" && length(var.destination_ranges) > 0 ? [1] : []
    content {
      destination_ranges = var.destination_ranges
    }
  }*/
  source_ranges           = var.direction == "INGRESS" ? var.source_ranges : []
  source_tags             = var.direction == "INGRESS" ? var.source_tags : []
  source_service_accounts = var.direction == "INGRESS" ? var.source_service_accounts : []
  destination_ranges      = var.direction == "EGRESS" ? var.destination_ranges : []
  
  allow {
    protocol  = "tcp"
    ports     = ["80", "8080"]
  }

  
  target_tags = var.target_tags
}