terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
  }
  cloud {
    organization = "bankabon"
    hostname = "app.terraform.io"

    workspaces {
      name = "test-switch-role"
    }
  }
  required_version = "~> 1.9.0"
}