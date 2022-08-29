variable "keybase-file-path" {
  type = string
  default = "/keybase/team/ethereum.devops/eth2/"
}


data "external" "metrics-ingress-user" {
  program = ["keybase", "fs", "read", "${var.keybase-file-path}/monitoring/observability-cluster/metrics-ingress-users/sync-test-ibm.json"]
}

