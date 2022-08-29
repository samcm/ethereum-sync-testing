resource "helm_release" "node-exporter" {
  name       = "node-exporter"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-node-exporter"

  values = [
    "${file("values/node-exporter.yaml")}"
  ]
}

resource "kubectl_manifest" "vmpodscrape-node-exporter" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMPodScrape
metadata:
  name: node-exporter
  labels:
    vmagent: common
spec:
  podMetricsEndpoints:
    - port: "metrics"
      scheme: http
  selector:
    matchLabels:
      app: prometheus-node-exporter
YAML
}