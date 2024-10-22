output "vpc_network" {
  value = google_compute_network.vpc_network
}
output "self_link" {
  value = google_compute_network.self_link
}
output "numeric_id" {
  value = google_compute_network.numeric_id
}
output "gateway_ipv4" {
  value = google_compute_network.gateway_ipv4
}