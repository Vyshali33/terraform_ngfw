output "name" {
  value = google_compute_subnetwork.subnet
}
output "creation_timestamp" {
  value = google_compute_subnetwork.subnet.creation_timestamp
}
output "self_link" {
  value = google_compute_subnetwork.subnet.self_link
}
output "ipv6_cidr_range" {
  value = google_compute_subnetwork.subnet.ipv6_cidr_range
}
output "internal_ipv6_prefix" {
  value = google_compute_subnetwork.subnet.internal_ipv6_prefix
}
