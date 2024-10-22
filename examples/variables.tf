variable "project_id" {
  type        = string
  description = "name of the project"
}
variable "name" {
  type        = string
  description = "name"
}
variable "description" {
  type        = string
  description = "name"
}
variable "auto_create_subnetworks" {
  type    = bool
  default = false
}
variable "routing_mode" {
  type    = string
  default = "GLOBAL"
}
variable "mtu" {
  type    = number
  default = 0
}
variable "enable_ula_internal_ipv6" {
  type    = bool
  default = false
}
variable "internal_ipv6_range" {
  type = string

}
variable "network_firewall_policy_enforcement_order" {
  type = string

}
variable "delete_default_routes_on_create" {
  type    = bool
  default = false

}
variable "ip_cidr_range"{
    type = string
}
variable "region"{
    type = string
}
variable "network"{
    type = string
}
variable "purpose"{
    type = string
}
variable "fw_name" {
  type = string
}
variable "network" {
  type = string
}
variable "direction" {
  description = "The direction of the firewall rule: either INGRESS or EGRESS"
  type        = string
  default     = "INGRESS"
  validation {
    condition     = contains(["INGRESS", "EGRESS"], var.direction)
    error_message = "Direction must be either 'INGRESS' or 'EGRESS'"
  }
}
variable "priority" {
  type = string
}
variable "source_ranges" {
    type = list(string)
    default = [] 
}
variable "source_tags" {
    type = list(string)
    default = [] 
}
variable "source_service_accounts" {
    type = list(string)
    default = [] 
}
variable "destination_ranges" {
    type = list(string)
    default = [] 
}
variable "destination_tags" {
    type = list(string)
    default = [] 
}