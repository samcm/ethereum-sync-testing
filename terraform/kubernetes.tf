variable "cluster_name" {
  type    = string
  default = "sync-testing"
}

variable "region" {
  type    = string
  default = "sgp1" # list available regions with `doctl compute region list`
}

locals {
  cluster_name = format("%s-%s", var.cluster_name, var.region)
  common_tags = [ local.cluster_name, "owner:samcm" ]
}


resource "digitalocean_kubernetes_cluster" "sync-testing" {
  name     = local.cluster_name
  region   = var.region
  version  = "1.22.8-do.1"
  vpc_uuid = digitalocean_vpc.sync-testing.id
  tags     = local.common_tags

  lifecycle {
    ignore_changes = [
      node_pool[0].node_count,
      node_pool[0].nodes,
    ]
  }

  node_pool {
    name       = "${local.cluster_name}-default"
    size       = "s-4vcpu-8gb-amd" # $48/month,  list available options with `doctl compute size list`
    labels = {}
    node_count = 1
    auto_scale = true
    max_nodes = 10
    min_nodes = 1
    tags       = concat(local.common_tags, ["default"])
  }

}
