variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "dns_zone_name" {
  default     = ""
  description = "The name of the DNS zone to create"
  type        = string
}
variable "dns_zone_dns_name" {
  default     = ""
  description = "The DNS name of the zone to create"
  type        = string
}
variable "dns_zone_description" {
  default     = ""
  description = "The description of the zone to create"
  type        = string
}