terraform {
  backend "gcs" {}
}

# data "google_iam_policy" "allUsers_objectViewer" {
#   binding {
#     role = "roles/storage.objectViewer"
#     members = [
#       "allUsers",
#     ]
#   }
# }
# resource "google_pubsub_topic" "notifications" {
#   name    = "notifications"
#   project = var.project_id
# }


resource "google_dns_managed_zone" "zone" {
  project     = var.project_id
  name        = var.dns_zone_name
  dns_name    = var.dns_zone_dns_name
  description = var.dns_zone_description
}

