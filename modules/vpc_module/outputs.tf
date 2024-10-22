output "vpc_network" {
  value = google_compute_network.vpc_network
}
output "vpc_name" {
  value = google_compute_network.vpc_network.name
}
output "self_link" {
  value = google_compute_network.vpc_network.self_link
}
output "numeric_id" {
  value = google_compute_network.vpc_network.numeric_id
}
output "gateway_ipv4" {
  value = google_compute_network.vpc_network.gateway_ipv4
}