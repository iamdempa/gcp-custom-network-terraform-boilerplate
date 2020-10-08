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

  subnetwork_name = "public-subnetwork"
  cidr = "10.0.0.0/21"
  subnetwork_region = "us-west2"
  network = module.network.network_name
  depends_on_resoures = [module.network]
  private_ip_google_access = "false"
}

# creating the private subnet 
module "private_subnet" {
  source = "./modules/subnetworks"

  subnetwork_name = "private-subnetwork"
  cidr = "10.0.8.0/21"
  subnetwork_region = "us-west2"
  network = module.network.network_name
  depends_on_resoures = [module.network]
  private_ip_google_access = "false"
}

# create the vm in public subnet
module "public_instance" {
  source = "./modules/vm"

  instance_name = "public-vm"
  machine_type = "e2-medium"
  vm_zone = "us-west2-a"
  network_tags = ["public-vm", "test"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.public_subnet.sub_network_name
  metadata_Name_value = "public_vm"
  
}


# create the vm in public subnet
module "private_instance" {
  source = "./modules/vm"

  instance_name = "private-vm"
  machine_type = "e2-medium"
  vm_zone = "us-west2-a"
  network_tags = ["public-vm", "test"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.private_subnet.sub_network_name
  metadata_Name_value = "private_vm"
}