resource "helm_release" "metrics-server" {
  depends_on = [
    data.digitalocean_kubernetes_versions.sync-testing,
  ]
  name       = "metrics-server"

  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  values = [
    "${file("values/metrics-server.yaml")}"
  ]
}

resource "kubectl_manifest" "vmpodscrape-metrics-server" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMPodScrape
metadata:
  name: metrics-server
  labels:
    vmagent: common
spec:
  podMetricsEndpoints:
  - port: "https"
    path: "/metrics"
    scheme: https
    tlsConfig:
      insecureSkipVerify: true
  selector:
    matchLabels:
      app.kubernetes.io/name: metrics-server
YAML
}