variable "project_id" {
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