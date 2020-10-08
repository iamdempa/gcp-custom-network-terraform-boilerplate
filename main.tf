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


# creating the network 
module "network" {
  source = "./modules/network"

  network_name = "network"
  auto_create_subnetworks = "false"
}

# creating the public subnet 
module "public_subnet" {
  source = "./modules/subnetworks"

  public_subnetwork_name = "public-subnetwork"
  public_cidr = "10.0.0.0/21"
  public_subnetwork_region = "us-west2"
  network = module.network.network_name
  private_ip_google_access = "false"
}

# creating the private subnet 
module "private_subnet" {
  source = "./modules/subnetworks"

  public_subnetwork_name = "private-subnetwork"
  public_cidr = "10.0.8.0/21"
  public_subnetwork_region = "us-west2"
  network = module.network.network_name
  private_ip_google_access = "false"
}