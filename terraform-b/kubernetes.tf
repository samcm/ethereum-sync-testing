resource "kubernetes_priority_class" "observability-critical" {
  metadata {
    name = "observability-critical"
  }

  value = 100
}

resource "kubernetes_namespace" "ethereum" {
  metadata {
    name = "ethereum"
  }
}