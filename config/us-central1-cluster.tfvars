project_id         = "sports-loop"
network_name       = "us-central1-network"
name               = "us-central1"
region             = "us-central1"
zones              = ["us-central1-a"]
service_account    = "terraform-service-account@sports-loop.iam.gserviceaccount.com"
machine_type       = "n2d-standard-4"
kubernetes_version = "1.28.7-gke.1026000"
release_channel    = "REGULAR"
logging_service    = "none"