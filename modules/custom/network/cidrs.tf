locals {
  cidr_ranges = {
    node_ip_ranges = {
      us-central1  = "10.150.0.0/20"
      europe-west2 = "10.152.0.0/20"
    }

    pod_ip_ranges = {
      us-central1  = "10.151.0.0/16"
      europe-west2 = "10.155.0.0/16"
    }

    services_ip_ranges = {
      us-central1  = "10.150.32.0/20"
      europe-west2 = "10.154.32.0/20"
    }
  }
}