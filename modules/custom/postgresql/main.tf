terraform {
  backend "gcs" {}
}

locals {
  read_replica_ip_configuration = {
    ipv4_enabled        = var.ipv4_enabled
    require_ssl         = var.require_ssl
    private_network     = var.private_network
    private_network     = try("projects/${var.project_id}/global/networks/${var.private_network}", null)
    authorized_networks = var.authorized_networks
  }
  read_replicas = [
    for replica, data in tolist(var.replicas) :
    {
      name             = replica
      zone             = try(data.zone, var.replica_zone)
      tier             = try(data.tier, var.replica_database_tier)
      ip_configuration = local.read_replica_ip_configuration
      database_flags   = try(data.database_flags, var.replica_database_flags)
      disk_autoresize  = null
      disk_size        = null
      disk_type        = try(data.disk_type, var.replica_disk_type)
      user_labels      = try(data.user_labels, var.replica_user_labels)
  }]
}

module "pg" {
  source               = "../../modules/gcp/postgresql"
  name                 = "${var.name}-${var.region}"
  random_instance_name = var.random_instance_name
  project_id           = var.project_id
  database_version     = var.database_version
  region               = var.region

  // Master configurations
  tier                            = var.database_tier
  zone                            = var.database_zone
  availability_type               = var.availability_type
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track

  deletion_protection = var.deletion_protection

  database_flags = var.database_flags

  user_labels = var.master_user_labels

  ip_configuration = {
    ipv4_enabled        = var.ipv4_enabled
    require_ssl         = var.require_ssl
    private_network     = try("projects/${var.project_id}/global/networks/${var.private_network}", null)
    authorized_networks = var.authorized_networks
  }

  backup_configuration = var.backup_configuration

  // Read replica configurations
  read_replica_name_suffix = var.read_replica_name_suffix

  read_replicas = local.read_replicas

  db_name      = "${var.name}-${var.region}"
  db_charset   = var.db_charset
  db_collation = var.db_collation

  additional_databases = var.additional_databases
  user_name            = var.master_username
  user_password        = var.master_password

  additional_users = var.additional_users
}
