resource "helm_release" "github-actions-runner-controller" {
  name       = "github-actions-runner-controller"

  depends_on = [
    helm_release.certmanager,
  ]

  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"

  values = [
    "${file("values/github-actions-runner-controller.yaml")}"
  ]

  set {
    name = "authSecret.github_app_id"
    value = "${data.external.github-actions-runner-token.result.appId}"
  }
  set {
    name = "authSecret.github_app_installation_id"
    value = "${data.external.github-actions-runner-token.result.installationId}"
  }
  set {
    name = "authSecret.github_app_private_key"
    value = "${base64decode(data.external.github-actions-runner-token.result.privateKey)}"
  }
}


resource "kubectl_manifest" "sync-test-runners" {
  depends_on = [
    helm_release.github-actions-runner-controller
  ]

  yaml_body = <<YAML

apiVersion: actions.summerwind.dev/v1alpha1
kind: RunnerDeployment
metadata:
  name: runner-deployment
spec:
  template:
    spec:
      repository: samcm/ethereum-sync-testing
      resources:
        requests:
          cpu: "80m"
          memory: "200Mi"
YAML
}

resource "kubectl_manifest" "sync-test-runners-autoscaler" {
  depends_on = [
    helm_release.github-actions-runner-controller
  ]

  yaml_body = <<YAML
apiVersion: actions.summerwind.dev/v1alpha1
kind: HorizontalRunnerAutoscaler
metadata:
  name: runner-deployment-autoscaler
spec:
  scaleTargetRef:
    name: runner-deployment
  minReplicas: 0
  maxReplicas: 30
  metrics:
  - type: TotalNumberOfQueuedAndInProgressWorkflowRuns
    repositoryNames:
    - samcm/ethereum-sync-testing
YAML
}
