# adding a firewall to the VPC
resource "google_compute_firewall" "firewall_rule" {
  name    = var.firewall_rule_name
  network = google_compute_network.kubernetes-vpc.name

  # ssh access, node_exporter (9100) and promethues (9090)
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "9100", "9090"]
  }

  # source_tags = ["kubernetes-ssh-all", "0.0.0.0/0"]
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["kube-master", "kube-minion"]
}