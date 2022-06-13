resource "helm_release" "victoriametrics-operator" {
  depends_on = [
    digitalocean_kubernetes_cluster.sync-testing,
  ]
  name       = "victoriametrics-operator"

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-operator"

  values = [
    "${file("values/victoriametrics-operator.yaml")}"
  ]
}