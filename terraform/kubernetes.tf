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
  version  = "1.23.10-do.0"
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
    max_nodes = 5
    min_nodes = 1
    tags       = concat(local.common_tags, ["default"])
  }

}


# # Dedicated pool of nodes for ethereum
# resource "digitalocean_kubernetes_node_pool" "ethereum-intel" {
#   lifecycle {
#     ignore_changes = [
#       node_count,
#       nodes,
#     ]
#   }

#   cluster_id = digitalocean_kubernetes_cluster.sync-testing.id
#   name       = "${local.cluster_name}-ethereum-intel"
#   size       = "s-8vcpu-16gb-intel" # $96/month
#   auto_scale = true
#   max_nodes = 15
#   min_nodes = 1
#   node_count =  1

#   tags       = concat(local.common_tags, ["ethereum"])

#   taint {
#     key    = "dedicated"
#     value  = "ethereum"
#     effect = "NoSchedule"
#   }
# }

# resource "digitalocean_kubernetes_node_pool" "ethereum-amd" {
#   lifecycle {
#     ignore_changes = [
#       node_count,
#       nodes,
#     ]
#   }

#   cluster_id = digitalocean_kubernetes_cluster.sync-testing.id
#   name       = "${local.cluster_name}-ethereum-amd"
#   size       = "s-8vcpu-16gb-amd" # $96/month
#   auto_scale = true
#   max_nodes = 15
#   min_nodes = 1
#   node_count =  1

#   tags       = concat(local.common_tags, ["ethereum"])

#   taint {
#     key    = "dedicated"
#     value  = "ethereum"
#     effect = "NoSchedule"
#   }
# }

# resource "digitalocean_kubernetes_node_pool" "ethereum-xxxl" {
#   lifecycle {
#     ignore_changes = [
#       node_count,
#       nodes,
#     ]
#   }

#   cluster_id = digitalocean_kubernetes_cluster.sync-testing.id
#   name       = "${local.cluster_name}-ethereum-xxxl"
#   size       = "so1_5-8vcpu-64gb" # 652/month
#   auto_scale = true
#   max_nodes = 22
#   min_nodes = 1
#   node_count =  1

#   tags       = concat(local.common_tags, ["ethereum"])

#   taint {
#     key    = "dedicated"
#     value  = "ethereum-xxxl"
#     effect = "NoSchedule"
#   }
# }

# resource "digitalocean_kubernetes_node_pool" "ethereum-large" {
#   lifecycle {
#     ignore_changes = [
#       node_count,
#       nodes,
#     ]
#   }

#   cluster_id = digitalocean_kubernetes_cluster.sync-testing.id
#   name       = "${local.cluster_name}-ethereum-large"
#   size       = "so1_5-4vcpu-32gb" # $250/month
#   auto_scale = true
#   max_nodes = 5
#   min_nodes = 1
#   node_count =  1

#   tags       = concat(local.common_tags, ["ethereum"])

#   taint {
#     key    = "dedicated"
#     value  = "ethereum-large"
#     effect = "NoSchedule"
#   }
# }

resource "kubernetes_priority_class" "observability-critical" {
  metadata {
    name = "observability-critical"
  }

  value = 100
}
