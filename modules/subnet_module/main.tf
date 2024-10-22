/*resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-subnet" 
  description   = "creating a subnet"    
  ip_cidr_range = var.subnet_cidr          
  region        = var.region
  network       = google_compute_network.vpc_network.self_link
}*/