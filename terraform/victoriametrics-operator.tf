resource "helm_release" "victoriametrics-operator" {
  depends_on = [
    data.digitalocean_kubernetes_versions.sync-testing,
  ]
  name       = "victoriametrics-operator"

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-operator"

  values = [
    "${file("values/victoriametrics-operator.yaml")}"
  ]
}