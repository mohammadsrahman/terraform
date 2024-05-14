project_id   = "sports-loop"
network_name = "us-central1-network"

nats = [
  {
    region  = "us-central1"
    nat_ips = ["https://www.googleapis.com/compute/v1/projects/sports-loop/regions/us-central1/addresses/nat-us-central1-external-ip"]
  },
]

subnets = {
  us-central1 = {
    region = "us-central1"
  }
}