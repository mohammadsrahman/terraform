module "gke" {
  source                             = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  kubernetes_version                 = var.kubernetes_version
  release_channel                    = var.release_channel
  project_id                         = var.project_id
  name                               = var.name
  region                             = var.region
  zones                              = var.zones
  network                            = var.network_name
  subnetwork                         = var.name
  ip_range_pods                      = "pods-ip-range"
  ip_range_services                  = "services-ip-range"
  create_service_account             = false
  service_account                    = var.service_account
  remove_default_node_pool           = true
  enable_private_endpoint            = false
  enable_private_nodes               = true
  master_ipv4_cidr_block             = var.master_ipv4_cidr_block
  add_cluster_firewall_rules         = true
  enable_vertical_pod_autoscaling    = true
  enable_resource_consumption_export = true
  //  resource_usage_export_dataset_id   = "k8s_clusters_data_set"
  maintenance_start_time       = var.maintenance_start_time
  maintenance_end_time         = var.maintenance_end_time
  maintenance_recurrence       = var.maintenance_recurrence
  master_global_access_enabled = false
  config_connector             = false
  dns_cache                    = false
  istio                        = false
  network_policy               = true
  network_policy_provider      = "CALICO"
  logging_service              = var.logging_service
  firewall_inbound_ports = [
    "10250",
    "443",
    "15017",
    "8443",
    "9443",
    "4443",
    "8080"
  ]
  node_pools = [
    {
      name               = "default-node-pool"
      preemptible        = false
      spot               = true
      machine_type       = var.machine_type
      node_locations     = join(",", var.zones)
      min_count          = var.min_count
      max_count          = var.max_count
      initial_node_count = var.initial_node_count
      version            = var.kubernetes_version
      disk_size_gb       = 50
    }
  ]

}

data "google_client_config" "default" {
}

data "google_project" "project" {
  project_id = var.project_id
}

# Create IAM bindings for external-dns and cert-manager for use with workload identity

locals {
  external-dns = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/external-dns/sa/external-dns"
  cert-manager = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/cert-manager/sa/cert-manager"
}

resource "google_project_iam_member" "external_dns" {
  member  = local.external-dns
  project = var.project_id
  role    = "roles/dns.admin"
}

resource "google_project_iam_member" "cert_manager" {
  member  = local.cert-manager
  project = var.project_id
  role    = "roles/dns.admin"
}