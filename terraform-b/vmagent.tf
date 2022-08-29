resource "kubernetes_secret" "metrics-ingress-user" {
  metadata {
    name = "metrics-ingress-user"
  }

  type = "kubernetes.io/basic-auth"

  data = {
    "username" = "${data.external.metrics-ingress-user.result.username}"
    "password" = "${data.external.metrics-ingress-user.result.password}"
  }
}

resource "kubernetes_secret" "metrics-ingress-user-eth" {
  metadata {
    name = "metrics-ingress-user"
    namespace = "ethereum"
  }

  type = "kubernetes.io/basic-auth"

  data = {
    "username" = "${data.external.metrics-ingress-user.result.username}"
    "password" = "${data.external.metrics-ingress-user.result.password}"
  }
}

resource "kubectl_manifest" "vmagent-common" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMAgent
metadata:
  name: vmagent-common
spec:
  selectAllByDefault: false
  podScrapeNamespaceSelector: {}
  podScrapeSelector:
    matchLabels:
      vmagent: common

  serviceScrapeNamespaceSelector: {}
  serviceScrapeSelector:
    matchLabels:
      vmagent: common

  nodeScrapeNamespaceSelector: {}
  nodeScrapeSelector:
    matchLabels:
      vmagent: common

  serviceScrapeNamespaceSelector: {}
  serviceScrapeSelector:
    matchLabels:
      vmagent: common

  probeNamespaceSelector: {}
  probeSelector:
    matchLabels:
      vmagent: common

  scrapeInterval: 15s
  resources:
    requests:
      cpu: 126m
      memory: 256Mi
  shardCount: 1
  replicaCount: 1

  inlineRelabelConfig: 
  - action: replace
    target_label: scraped_pod
    source_labels: [pod]
  - action: replace
    target_label: scraped_container
    source_labels: [container]
  - action: replace
    target_label: scraped_namespace
    source_labels: [namespace]  


  - action: replace
    target_label: pod
    source_labels: [exported_pod]
  - action: replace
    target_label: container
    source_labels: [exported_container]
  - action: replace
    target_label: namespace
    source_labels: [exported_namespace]

  - action: labeldrop
    regex: exported_pod
  - action: labeldrop
    regex: exported_container
  - action: labeldrop
    regex: exported_namespace


  remoteWrite:
  - url: "https://victoriametrics.ethdevops.io/insert/0/prometheus/api/v1/write"
    basicAuth:
      username:
        name: metrics-ingress-user
        key: username
      password: 
        name: metrics-ingress-user
        key: password
YAML
}

resource "kubectl_manifest" "vmagent-ethereum" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMAgent
metadata:
  name: vmagent-ethereum
  namespace: ethereum
spec:
  selectAllByDefault: true

  podScrapeSelector:
    matchLabels:
      vmagent: ethereum

  serviceScrapeSelector:
    matchLabels:
      vmagent: ethereum

  nodeScrapeSelector:
    matchLabels:
      vmagent: ethereum

  serviceScrapeSelector:
    matchLabels:
      vmagent: ethereum
    
  probeSelector:
    matchLabels:
      vmagent: ethereum

  scrapeInterval: 15s
  resources:
    requests:
      cpu: 126m
      memory: 256Mi
  shardCount: 1
  replicaCount: 1

  metricRelabelConfig:
  - action: replace
    target_label: instance
    source_labels: [job_name]

  inlineRelabelConfig: 
  - action: replace
    target_label: scraped_pod
    source_labels: [pod]
  - action: replace
    target_label: scraped_container
    source_labels: [container]
  - action: replace
    target_label: scraped_namespace
    source_labels: [namespace]  


  - action: replace
    target_label: pod
    source_labels: [exported_pod]
  - action: replace
    target_label: container
    source_labels: [exported_container]
  - action: replace
    target_label: namespace
    source_labels: [exported_namespace]
  - action: replace
    target_label: instance
    source_labels: [job_name]

  - action: labeldrop
    regex: exported_pod
  - action: labeldrop
    regex: exported_container
  - action: labeldrop
    regex: exported_namespace


  remoteWrite:
  - url: "https://victoriametrics.ethdevops.io/insert/0/prometheus/api/v1/write"
    basicAuth:
      username:
        name: metrics-ingress-user
        key: username
      password: 
        name: metrics-ingress-user
        key: password
YAML
}

resource "kubectl_manifest" "vmpodscrape-sync-tests" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMPodScrape
metadata:
  name: ethereum-sync-tests
  namespace: ethereum
  labels:
    vmagent: ethereum
spec:
  podMetricsEndpoints:
  - port: exe-metrics
    scheme: http
  - port: con-metrics
    scheme: http
  - port: eth-metrics
    scheme: http
  - port: coord-metrics
    scheme: http
  podTargetLabels:
  - consensus_client
  - execution_client
  - network
  - testnet
  - job-name
  - app.kubernetes.io/instance
  selector:
    matchLabels:
      app.kubernetes.io/name: est
YAML
}

resource "kubectl_manifest" "vmpodscrape-ethereum-nodes" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMPodScrape
metadata:
  name: ethereum-nodes
  namespace: ethereum
  labels:
    vmagent: ethereum
spec:
  podMetricsEndpoints:
  - port: http
    scheme: http
  podTargetLabels:
  - consensus_client
  - execution_client
  - network
  - testnet
  - app.kubernetes.io/instance
  - ethereum_instance
  - job-name
  selector:
    matchLabels:
      app.kubernetes.io/name: ethereum-metrics-exporter
YAML
}