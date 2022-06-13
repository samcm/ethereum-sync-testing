# data "digitalocean_kubernetes_versions" "sync-testing" {
#   version_prefix = "1.22.7"
# }

resource "digitalocean_vpc" "sync-testing" {
  name     = local.cluster_name
  region   = var.region
  ip_range = "10.142.0.0/16"
}

resource "digitalocean_firewall" "firewall" {
  name = local.cluster_name

  tags = [local.cluster_name]

  inbound_rule {
    protocol         = "udp"
    port_range       = "30000-32768"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "30000-32768"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}