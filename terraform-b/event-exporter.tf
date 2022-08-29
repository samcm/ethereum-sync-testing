resource "helm_release" "event-exporter" {
  name       = "event-exporter"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kubernetes-event-exporter"

  values = [
    "${file("values/event-exporter.yaml")}"
  ]
}
