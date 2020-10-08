# Provide 
provider "google" {
  # credentials = file("token.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

# Configure the backend (variables are not allowed for backend configuration, setting the credentials 
# through the gitlab cicd variables)
terraform {
  backend "gcs" {
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
  network_tags = ["private-vm", "test"]
  machine_image = "ubuntu-1804-bionic-v20200317"
  subnetwork = module.private_subnet.sub_network_name
  metadata_Name_value = "private_vm"
}

# create firewall rule with ssh access to the public instance/s
module "firewall_rule_ssh_all" {
  source = "./modules/firewall_rules"

  firewall_rule_name = "ssh-all-public-instances"
  network = module.network.network_name
  protocol = "tcp"
  ports = ["22"]
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["public-vm"]
}


# create firewall rule to access only the public vm
module "firewall_rule_public_vm" {
  source = "./modules/firewall_rules"

  firewall_rule_name = "access-public-vm"
  network = module.network.network_name
  protocol_type = "icmp"
  # ports = [""]
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["public-vm"]
}


# resource "google_compute_firewall" "default" {
#   name    = "test-firewall"
#   network = module.network.network_name

#   allow {
#     protocol = "icmp"
#   }

#   source_ranges = ["0.0.0.0/0"]
#   target_tags = ["public-vm"]
# }