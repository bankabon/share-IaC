terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
  cloud {
    organization = "<orfanization>"
    hostname = "app.terraform.io"

    workspaces {
      name = "<workspace>"
    }
  }
  required_version = "~> 1.9.0"
}