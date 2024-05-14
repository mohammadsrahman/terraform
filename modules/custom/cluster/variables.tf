variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "network_name" {
  description = "The VPC network to host the cluster in"
  default     = "default"
}

variable "name" {
  description = "A suffix to append to the default cluster name"
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "zones" {
  description = "The zones to host the cluster in"
  default     = []
}

variable "service_account" {
  description = "Service account to associate to the nodes in the cluster"
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "min_nodes" {
  default = "1"
}

variable "max_count" {
  default = "20"
}

variable "initial_node_count" {
  default = "1"
}

variable "kubernetes_version" {
}

variable "maintenance_start_time" {
  default = "1970-01-01T12:00:00Z"
}

variable "release_channel" {
  type        = string
  default     = null
  description = "The release channel of this cluster"
}

variable "logging_service" {
  type        = string
  description = "The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none"
  default     = "logging.googleapis.com/kubernetes"
}