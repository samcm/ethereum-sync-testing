resource "helm_release" "victoriametrics-operator" {
  name       = "victoriametrics-operator"

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-operator"

  values = [
    "${file("values/victoriametrics-operator.yaml")}"
  ]
}