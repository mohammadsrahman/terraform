terraform {
  backend "gcs" {}
}

module "network" {
  source             = "../../modules/gcp/network"
  project_id         = var.project_id
  network_name       = var.network_name
  subnets            = var.subnets
  nats               = var.nats
  node_ip_ranges     = local.cidr_ranges.node_ip_ranges
  pod_ip_ranges      = local.cidr_ranges.pod_ip_ranges
  services_ip_ranges = local.cidr_ranges.services_ip_ranges
}

//module "private_service_access" {
//  source      = "../../modules/gcp/private_service_access"
//  project_id  = var.project_id
//  vpc_network = var.network_name
//}