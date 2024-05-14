locals {
  subnets = [
    for key, subnet in var.subnets : {
      subnet_name           = key
      subnet_ip             = var.node_ip_ranges[key]
      subnet_region         = subnet.region
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    for key, subnet in var.subnets :
    key => [
      {
        range_name    = "pods-ip-range"
        ip_cidr_range = var.pod_ip_ranges[key]
      },
      {
        range_name    = "services-ip-range"
        ip_cidr_range = var.services_ip_ranges[key]
      },
    ]
  }
}

module "network" {
  source           = "terraform-google-modules/network/google"
  version          = "9.1.0"
  project_id       = var.project_id
  network_name     = var.network_name
  subnets          = local.subnets
  secondary_ranges = local.secondary_ranges

}

resource "google_compute_router" "router" {
  count   = length(var.nats)
  project = var.project_id
  network = module.network.network_name
  region  = var.nats[count.index].region
  name    = "${var.network_name}-${var.nats[count.index].region}-router"
}

resource "google_compute_router_nat" "main" {
  count                              = length(var.nats)
  project                            = var.project_id
  region                             = var.nats[count.index].region
  name                               = "${var.network_name}-${var.nats[count.index].region}-nat"
  router                             = google_compute_router.router[count.index].name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = var.nats[count.index].nat_ips
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
