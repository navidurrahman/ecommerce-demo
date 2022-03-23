terraform {
  required_providers {
    g42cloud = {
      source  = "g42cloud-terraform/g42cloud"
      version = "= 1.3.0"
    }
    helm = {
      version = ">= 2.4.1"
    }
  }
}
