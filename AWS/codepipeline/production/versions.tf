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
      name = "<work space name>"
    }
  }
  required_version = "~> 1.2.0"
}
