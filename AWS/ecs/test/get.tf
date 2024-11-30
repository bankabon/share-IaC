data "terraform_remote_state" "created-vpc" {
  backend = "remote"
  config = {
    organization = "<terrafom cloud orfanization>"
    workspaces = {
      name = "<get created VPC terraform cloud>"
    }
  }
}

data "aws_caller_identity" "account" {}


