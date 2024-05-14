output "name" {
  description = "Cluster name"
  value       = module.cluster.name
}

output "type" {
  description = "Cluster type (regional / zonal)"
  value       = module.cluster.type
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.cluster.location
}

output "region" {
  description = "Cluster region"
  value       = module.cluster.region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.cluster.zones
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.cluster.endpoint
}

output "min_master_version" {
  description = "Minimum master kubernetes version"
  value       = module.cluster.min_master_version
}

output "master_authorized_networks_config" {
  description = "Networks from which access to master is permitted"
  value       = module.cluster.master_authorized_networks_config
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.cluster.master_version
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.cluster.ca_certificate
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = module.cluster.node_pools_names
}

output "service_account" {
  description = "The service account to default running nodes as if not overridden in `node_pools`."
  value       = module.cluster.service_account
}

output "access_token" {
  value     = module.cluster.access_token
  sensitive = true
}