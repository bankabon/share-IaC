terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
  cloud {
    organization = "<terraform cloud orfanization>"
    hostname     = "app.terraform.io"

    workspaces {
      name = "bankabon-appruner-container"
    }
  }
  required_version = "~> 1.2.0"
}