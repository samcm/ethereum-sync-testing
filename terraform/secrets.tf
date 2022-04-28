variable "keybase-file-path" {
  type = string
  default = "/keybase/team/ethereum.devops/eth2/monitoring/observability-cluster"
}


data "external" "metrics-ingress-user" {
  program = ["keybase", "fs", "read", "${var.keybase-file-path}/metrics-ingress-users/sync-test-kubes.json"]
}
