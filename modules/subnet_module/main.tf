resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet"
  description   = "creating a subnet"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = var.network
  purpose       = var.purpose
}
