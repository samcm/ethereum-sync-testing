resource "helm_release" "local-path-provisioner" {
  depends_on = [
    data.digitalocean_kubernetes_versions.sync-testing,
  ]
  name       = "local-path-provisioner"

  repository = "https://ebrianne.github.io/helm-charts"
  chart      = "local-path-provisioner"

  values = [
    "${file("values/local-path-provisioner.yaml")}"
  ]
}
