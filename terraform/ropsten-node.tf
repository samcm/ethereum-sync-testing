resource "helm_release" "ropsten-geth-lighthouse-001" {
  name       = "ropsten-geth-lighthouse-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "geth"
  namespace = "ethereum"
  values = [
    "${file("values/ropsten-geth-lighthouse-001.yaml")}"
  ]
}

resource "helm_release" "ropsten-lighthouse-geth-001" {
  name       = "ropsten-lighthouse-geth-001"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "lighthouse"
  namespace = "ethereum"
  values = [
    "${file("values/ropsten-lighthouse-geth-001.yaml")}"
  ]
}

resource "helm_release" "ropsten-lighthouse-geth-001-metrics" {
  name       = "ropsten-lighthouse-geth-001-metrics"

  repository = "https://skylenet.github.io/ethereum-helm-charts"
  chart      = "ethereum-metrics-exporter"
  namespace = "ethereum"
  values = [
    "${file("values/ropsten-geth-lighthouse-001-metrics.yaml")}"
  ]
}


resource "kubernetes_config_map" "ropsten-geth-lighthouse-001" {
  metadata {
    name = "ropsten-geth-lighthouse-001"
    namespace = "ethereum"
  }

  data = {
    jwtsecret = ""
  }
}
