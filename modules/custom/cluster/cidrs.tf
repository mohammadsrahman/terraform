locals {
  cidr_ranges = {
    master_ipv4_cidr_blocks = {
      dev          = "172.16.0.0/28"
      test         = "172.16.0.16/28"
      qa           = "172.16.0.32/28"
      uat          = "172.16.0.48/28"
      stag         = "172.16.0.64/28"
      prod         = "172.16.1.0/28"
      management   = "172.16.1.16/28"
      us-central1  = "172.16.1.32/28"
      asia-east2   = "172.16.1.48/28"
      europe-west2 = "172.16.1.64/28"
    }
  }
}