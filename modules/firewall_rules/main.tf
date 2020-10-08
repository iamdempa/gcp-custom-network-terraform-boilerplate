# adding a firewall to the VPC
resource "google_compute_firewall" "firewall_rule" {
  name    = var.firewall_rule_name
  network = var.network

  allow {
    protocol = var.protocol
    # ports    = var.ports
  }

  # source_tags = ["kubernetes-ssh-all", "0.0.0.0/0"]
  source_ranges = var.source_ranges
  target_tags = var.target_tags
}