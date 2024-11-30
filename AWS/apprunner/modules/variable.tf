variable "name" {}

variable "env" {}

variable "github_repositoryurl" {}

variable "branch" {}

variable "domain" {}

variable "codebuild_subnet" {}

variable "apprunner_subnet" {
  type = list(string)
}

variable "vpc_id" {}

variable "use_github" {
  type    = bool
  default = true
}

variable "domain_name" {}

variable "github_account_arn" {}

variable "code-pipeline-branch" {}

variable "ConectionArn" {}

variable "code-pipeline-repository" {}

variable "ecr_uri" {}


#アカウントID
data "aws_caller_identity" "self" {}