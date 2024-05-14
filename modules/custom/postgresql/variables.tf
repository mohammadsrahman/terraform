variable "project_id" {
  type        = string
  description = "The project to run tests against"
}

variable "name" {
  type        = string
  description = "The name for Cloud SQL instance"
  default     = "tf-pg-ha"
}

variable "private_network" {
  type        = string
  description = "The name of the Private Network"
  default     = ""
}

variable "region" {
  type        = string
  description = "The region for Cloud SQL instance"
  default     = "us-central1"
}

variable "database_version" {
  type        = string
  description = "The Postgres DB Version"
  default     = "POSTGRES_9_6"
}

variable "database_tier" {
  type        = string
  description = "The Postgres DB tier"
  default     = "db-custom-2-13312"

}

variable "ipv4_enabled" {
  default = true
}
variable "require_ssl" {
  default = false
}

variable "database_zone" {
  type        = string
  description = "The Postgres DB Zone"
  default     = "us-central-c"
}

variable "availability_type" {
  type        = string
  description = "The availability type for the master instance"
  default     = "ZONAL"
}

variable "master_username" {
  type        = string
  description = "The master Username"
  default     = null
}

variable "master_password" {
  type        = string
  description = "The master Password"
  default     = null
}


variable "external_ip_range" {
  type        = string
  description = "The ip range to allow connecting from/to Cloud SQL"
  default     = "192.10.10.10/32"
}
variable "authorized_networks" {
  default     = []
  description = "Authorizesed networks that can access the database"
}

variable "additional_databases" {
  default     = []
  description = "Additional databases to add to the instance"
}

variable "additional_users" {
  default     = []
  description = "Additional Users to add"
}

variable "db_charset" {
  type    = string
  default = "UTF8"
}

variable "db_collation" {
  type    = string
  default = "en_US.UTF8"
}

variable "disk_type" {
  type    = string
  default = "PD_HDD"
}

variable "ip_configuration" {
  type = object({
    ipv4_enabled    = bool
    require_ssl     = bool
    private_network = bool
    authorized_networks = list(object({
      name  = string
      value = string
    }))
  })
  default = {
    ipv4_enabled        = true
    require_ssl         = true
    private_network     = null
    authorized_networks = []
  }
}

variable "random_instance_name" {
  default = false
}

variable "maintenance_window_day" {
  type    = number
  default = 7
}

variable "maintenance_window_hour" {
  type    = number
  default = 12
}

variable "maintenance_window_update_track" {
  type    = string
  default = "stable"
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "database_flags" {
  type = list(map(string))
  default = [{
    name  = "autovacuum",
    value = "off"
  }]
}

variable "disk_autoresize" {
  default = ""
}

variable "disk_size" {
  default = ""
}

variable "master_user_labels" {
  type    = map(string)
  default = {}
}

variable "backup_configuration" {
  type = map(any)
  default = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
  }
}

// Replicas
variable "replica_ip_configuration" {
  type = object({
    ipv4_enabled    = bool
    require_ssl     = bool
    private_network = bool
    authorized_networks = list(object({
      name  = string
      value = string
    }))
  })
  default = null
}

variable "read_replica_name_suffix" {
  default = "-"
}

variable "replica_database_flags" {
  type = list(map(string))
  default = [{
    name  = "autovacuum",
    value = "off"
  }]
}

variable "replicas" {

}

variable "replica_zone" {
  type    = string
  default = "us-central1-a"
}

variable "replica_database_tier" {
  type        = string
  description = "The Postgres DB tier for a replica"
  default     = "db-custom-2-13312"

}

variable "replica_disk_type" {
  type    = string
  default = "PD_HDD"
}

variable "replica_user_labels" {
  type    = map(string)
  default = {}
}