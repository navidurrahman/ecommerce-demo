provider "g42cloud" {}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig.json"
  }
}
