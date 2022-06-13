resource "helm_release" "promtail" {
  name       = "promtail"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"

  values = [
    "${file("values/promtail.yaml")}"
  ]

  set {
    name = "config.clientConfigs[0].basic_auth.username"
    value = "${data.external.metrics-ingress-user.result.username}"
  }
  
  set {
    name = "config.clientConfigs[0].basic_auth.password"
    value = "${data.external.metrics-ingress-user.result.password}"
  }
}
