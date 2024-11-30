data "terraform_remote_state" "created-vpc" {
  backend = "remote"
  config = {
    organization = "<terraform cloud orfanization>"
    workspaces = {
      name = "<get terraform vpc workspace>"
    }
  }
}