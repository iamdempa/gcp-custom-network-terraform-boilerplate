# Provide 
provider "google" {
  credentials = file("token.json")
  project     = var.project_name
  region      = var.region
  zone        = var.zone
}

# Configure the backend
terraform {
  backend "gcs" {
    bucket      = var.bucket_name
    prefix      = var.prefix
    credentials = var.token_path
  }
}

module "network" {
  source = "modules/network"

  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "(YOUR_BUCKET_NAME)"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}