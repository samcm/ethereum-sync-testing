resource "helm_release" "vmagent-kube-resources" {
  name       = "vmagent-kube-resources"

  repository = "https://victoriametrics.github.io/helm-charts"
  chart      = "victoria-metrics-agent"

  values = [
    "${file("values/vmagent-kube-resources.yaml")}"
  ]
}
