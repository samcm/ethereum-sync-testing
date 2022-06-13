resource "helm_release" "kube-state-metrics" {
  depends_on = [
    digitalocean_kubernetes_cluster.sync-testing,
  ]
  name       = "kube-state-metrics"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"

  values = [
    "${file("values/kube-state-metrics.yaml")}"
  ]
}

resource "kubectl_manifest" "vmpodscrape-kube-state-metrics" {
  depends_on = [
    helm_release.victoriametrics-operator,
  ]
  yaml_body = <<YAML
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMPodScrape
metadata:
  name: kube-state-metrics
  labels:
    vmagent: common
spec:
  podMetricsEndpoints:
    - port: "http"
      scheme: http
  selector:
    matchLabels:
      app.kubernetes.io/name: kube-state-metrics
YAML
}