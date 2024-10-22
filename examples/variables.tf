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