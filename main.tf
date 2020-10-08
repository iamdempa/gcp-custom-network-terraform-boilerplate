# Provide 
provider "google" {
  credentials = file("token.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

# Configure the backend (variables are not allowed for backenc configuration)
terraform {
  backend "gcs" {
    bucket      = "tf_backend_gcp_banuka_jana_jayarathna_k8s"
    prefix      = "terraform/gcp/boilerplate"
    credentials = "./token.json"
  }
}

module "network_boiler" {
  source = "./modules/network"

  network_name = "network-boilerplate"
  auto_create_subnetworks = "false"
}