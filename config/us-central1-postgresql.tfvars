project_id       = "sportsloop"
name             = "dev-pgdb" //if you delete this db you have to wait 1 week to reuse the name
region           = "us-central1"
database_version = "POSTGRES_9_6"
private_network  = "dev-network"
database_tier    = "db-custom-2-13312" // Legacy Name:db-n1-highmem-2 vCPU:2	Memory:13312 MBs
database_zone    = "us-central1-c"
//authorized_networks = [{
//  name  = "my-vpn"
//  value = "192.10.10.10/32"
//}]
availability_type = "REGIONAL" // "REGIONAL" MAKES IT HA
master_username   = "postgresql"
master_password   = "e3Cnr7rFcoLlD0DM"
// Each replica can be overided as followed
//  {
//    zone = "us-central1-a"
//    tier = "db-custom-2-13312"
//    disk_type = "HDD"
//    user_labels = {
//      postgres = "postgresql"
//    }
//    replica_database_flags = [{
//      name  = "autovacuum",
//      value = "off"
//    }]
//  },

// Zone attribute is required
replicas = [
  {
    zone = "us-central1-a"
  },
  {
    zone = "us-central1-b"
  },
  {
    zone = "us-central1-c"
  },
]


additional_databases = [
  {
    name      = "notejam"
    charset   = "UTF8"
    collation = "en_US.UTF8"
  }
]
additional_users = [
  {
    name     = "tftest2"
    password = "abcdefg"
    host     = "localhost"
  },
  {
    name     = "tftest3"
    password = "abcdefg"
    host     = "localhost"
  },
]

master_user_labels = {
  instance = "master"
  user     = "postgresql"
}
replica_user_labels = {
  instance = "replica"
  user     = "postgresql"
}

backup_configuration = {
  enabled                        = true
  start_time                     = "20:55"
  location                       = null
  point_in_time_recovery_enabled = true
}
