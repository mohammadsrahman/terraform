variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "network_name" {
  description = "The VPC network created to host the cluster in"
}

variable "nats" {
  type = list(object({
    region  = string
    nat_ips = list(string)
  }))
}

variable "subnets" {
  type = map(object({
    region = string
  }))
}

variable "node_ip_ranges" {}
variable "pod_ip_ranges" {}
variable "services_ip_ranges" {}
