terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
  cloud {
    organization = "bankabon"
    hostname     = "app.terraform.io"

    workspaces {
      name = "bankabon-newrelic"
    }
  }
  required_version = "~> 1.2.0"
}