terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = ">= 1.33.0"
    }
  }

  cloud {
    organization = "TecBrix"

    workspaces {
      name = "ecommerce-dev"
    }
  }
}
