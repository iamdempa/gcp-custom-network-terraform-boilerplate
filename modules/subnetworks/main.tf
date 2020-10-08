resource "google_compute_subnetwork" "public-subnetwork" {
  name          = var.public_subnetwork_name
  ip_cidr_range = var.public_cidr
  region        = var.public_subnetwork_region
  network       = var.network
  private_ip_google_access = "false"
}
