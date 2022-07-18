variable "ropsten-consensus-clients" {
  default = {
    "teku": 31700,
    "prysm": 31702,
    "nimbus": 31704,
    "lighthouse": 31706,
    "lodestar": 31708,
  }
}

resource "helm_release" "ropsten-execution-client" {
  for_each = var.ropsten-consensus-clients

  name       = "ropsten-checkpointer-geth-${each.key}-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "geth"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/shared.yaml")}",
    "${file("values/ethereum/tolerations.yaml")}",
    "${file("values/ethereum/execution.yaml")}"
  ]

  set {
    name = "fullNameOverride"
    value = "ropsten-checkpointer-geth-${each.key}-001"
  }

  set {
    name = "podLabels.ethereum-instance"
    value = "${each.key}"
  }

  set {
    name = "p2pNodePort.port"
    value = each.value
  }
}

# resource "helm_release" "ropsten-checkpointer-prysm-geth-001" {
#   name       = "ropsten-checkpointer-prysm-geth-001"

#   repository = "https://skylenet.github.io/ethereum-helm-charts"
#   chart      = "prysm"
#   namespace = "ethereum"
#   values = [
#     "${file("values/ethereum/shared.yaml")}",
#     "${file("values/ethereum/tolerations.yaml")}",
#     "${file("values/ethereum/clients/prysm.yaml")}"
#   ]

#   set {
#     name = "fullNameOverride"
#     value = "ropsten-checkpointer-prysm-geth-001"
#   }

#   set {
#     name = "podLabels.ethereum-instance"
#     value = "ropsten-checkpointer-prysm-geth-001"
#   }

#   set {
#     name = "extraArgs[2]"
#     value = "--http-web3provider=http://ropsten-checkpointer-geth-prysm-001:8551"
#   }
# }

resource "helm_release" "ropsten-checkpointer-lighthouse-geth-001" {
  name       = "ropsten-checkpointer-lighthouse-geth-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "lighthouse"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/shared.yaml")}",
    "${file("values/ethereum/tolerations.yaml")}",
    "${file("values/ethereum/clients/lighthouse.yaml")}"
  ]

  set {
    name = "fullNameOverride"
    value = "ropsten-checkpointer-lighthouse-geth-001"
  }

  set {
    name = "podLabels.ethereum-instance"
    value = "ropsten-checkpointer-lighthouse-geth-001"
  }

  set {
    name = "extraArgs[2]"
    value = "--execution-endpoints=http://ropsten-checkpointer-geth-lighthouse-001:8551"
  }

  set {
    name = "extraArgs[3]"
    value = "--eth1-endpoints=http://ropsten-checkpointer-geth-lighthouse-001:8545"
  }
}

resource "helm_release" "ropsten-checkpointer-lodestar-geth-001" {
  name       = "ropsten-checkpointer-lodestar-geth-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "lodestar"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/shared.yaml")}",
    "${file("values/ethereum/tolerations.yaml")}",
    "${file("values/ethereum/clients/lodestar.yaml")}"
  ]

  set {
    name = "fullNameOverride"
    value = "ropsten-checkpointer-lodestar-geth-001"
  }

  set {
    name = "podLabels.ethereum-instance"
    value = "ropsten-checkpointer-lodestar-geth-001"
  }

  set {
    name = "extraArgs[3]"
    value = "--execution.urls=http://ropsten-checkpointer-geth-lodestar-001:8551"
  }
}

resource "helm_release" "ropsten-checkpointer-nimbus-geth-001" {
  name       = "ropsten-checkpointer-nimbus-geth-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "nimbus"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/shared.yaml")}",
    "${file("values/ethereum/tolerations.yaml")}",
    "${file("values/ethereum/clients/nimbus.yaml")}"
  ]

  set {
    name = "fullNameOverride"
    value = "ropsten-checkpointer-nimbus-geth-001"
  }

  set {
    name = "podLabels.ethereum-instance"
    value = "ropsten-checkpointer-nimbus-geth-001"
  }

  set {
    name = "extraArgs[2]"
    value = "--web3-url=http://ropsten-checkpointer-geth-nimbus-001:8551"
  }
}

resource "helm_release" "ropsten-checkpointer-teku-geth-001" {
  name       = "ropsten-checkpointer-teku-geth-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "teku"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/shared.yaml")}",
    "${file("values/ethereum/tolerations.yaml")}",
    "${file("values/ethereum/clients/teku.yaml")}"
  ]

  set {
    name = "fullNameOverride"
    value = "ropsten-checkpointer-teku-geth-001"
  }

  set {
    name = "podLabels.ethereum-instance"
    value = "ropsten-checkpointer-teku-geth-001"
  }

  set {
    name = "extraArgs[2]"
    value = "--eth1-endpoints=http://ropsten-checkpointer-geth-teku-001:8545"
  }
  
  set {
    name = "extraArgs[3]"
    value = "--ee-endpoint=http://ropsten-checkpointer-geth-teku-001:8551"
  }
}

resource "helm_release" "ropsten-ethereum-metrics" {
  for_each = var.ropsten-consensus-clients

  name       = "ropsten-checkpointer-${each.key}-geth-001-metrics"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "ethereum-metrics-exporter"
  namespace = "ethereum"
  values = [
    "${file("values/ethereum/metrics.yaml")}"
  ]

  set {
    name = "fullnameOverride"
    value = "ropsten-checkpointer-geth-${each.key}-001-metrics"
  }

  set {
    name = "podLabels.job_name"
    value = "ropsten-checkpointer-geth-${each.key}-001"
  }
  
  set {
    name = "podLabels.ethereum_instance"
    value = "ropsten-checkpointer-geth-${each.key}-001"
  }

  set {
    name = "podLabels.consensus_client"
    value = each.key
  }

  set {
    name = "config.conesnsus.url"
    value = "http://ropsten-checkpointer-${each.key}-geth-001:5052"
  }
  
  set {
    name = "config.execution.url"
    value = "http://ropsten-checkpointer-geth-${each.key}-001:8545"
  }
}

resource "kubernetes_config_map" "shared-jwt-secret" {
  metadata {
    name = "shared-jwt-secret"
    namespace = "ethereum"
  }

  data = {
    jwtsecret = ""
  }
}
