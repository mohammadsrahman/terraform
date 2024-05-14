variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "network_name" {
  description = "The VPC network to host the cluster in"
  default     = "default"
}

variable "routing_mode" {
  description = "The VPC network to host the cluster in"
  default     = "GLOBAL"
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