terraform {
  backend "gcs" {}
}

module "cluster" {
  source                 = "../../modules/gcp/cluster"
  project_id             = var.project_id
  name                   = var.name
  region                 = var.region
  zones                  = var.zones
  network_name           = var.network_name
  subnetwork             = var.name
  service_account        = var.service_account
  machine_type           = var.machine_type
  min_count              = var.min_nodes
  initial_node_count     = var.initial_node_count
  master_ipv4_cidr_block = local.cidr_ranges.master_ipv4_cidr_blocks[var.name]
  kubernetes_version     = var.kubernetes_version
  release_channel        = var.release_channel
  maintenance_start_time = var.maintenance_start_time
  logging_service        = var.logging_service
}

provider "kubernetes" {
  host                   = "https://${module.cluster.endpoint}"
  token                  = module.cluster.access_token
  cluster_ca_certificate = base64decode(module.cluster.ca_certificate)
}

