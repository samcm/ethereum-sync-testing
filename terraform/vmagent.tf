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

resource "kubectl_manifest" "vmagent-common" {
  depends_on = [
    data.digitalocean_kubernetes_versions.sync-testing,
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMAgent
metadata:
  name: vmagent-common
spec:
  podScrapeNamespaceSelector: {}
  podScrapeSelector:
    vmagent: common

  serviceScrapeNamespaceSelector: {}
  serviceScrapeSelector:
    vmagent: common

  nodeScrapeNamespaceSelector: {}
  nodeScrapeSelector:
    vmagent: common

  serviceScrapeNamespaceSelector: {}
  serviceScrapeSelector:
    vmagent: common
    
  probeNamespaceSelector: {}
  probeSelector:
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