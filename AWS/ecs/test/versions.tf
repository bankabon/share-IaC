terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
  cloud {
    organization = "<terraform cloud orfanization>"
    hostname     = "app.terraform.io"

    workspaces {
      name = "<terraform cloud workspace>"
    }
  }
  required_version = "~> 1.2.0"
}
