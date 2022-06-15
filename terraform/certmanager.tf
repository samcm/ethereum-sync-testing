resource "helm_release" "certmanager" {
  name       = "certmanager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [
    "${file("values/certmanager.yaml")}"
  ]
}

resource "kubectl_manifest" "letsencrypt-staging" {
  depends_on = [
    helm_release.certmanager
  ]

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: sam.calder-mason@ethereum.org
    privateKeySecretRef:
      name: letsencrypt-staging
    solvers:
      - http01:
          ingress:
            class: ingress-nginx-public
YAML
}

resource "kubectl_manifest" "letsencrypt-production" {
  depends_on = [
    helm_release.certmanager
  ]

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: sam.calder-mason@ethereum.org
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
      - http01:
          ingress:
            class: ingress-nginx-public
YAML
}