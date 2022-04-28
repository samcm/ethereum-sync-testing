data "digitalocean_kubernetes_versions" "sync-testing" {
  version_prefix = "1.22.7"
}

resource "digitalocean_vpc" "sync-testing" {
  name     = local.cluster_name
  region   = var.region
  ip_range = "10.142.0.0/16"
}
