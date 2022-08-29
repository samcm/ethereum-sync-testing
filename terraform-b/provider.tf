provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "ibm-sync-tests"
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "ibm-sync-tests"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "ibm-sync-tests"
}

provider "external" {}