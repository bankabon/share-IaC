variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "subnet_ids_ecs" {
  type = list(string)
}

variable "subnet_ids_alb" {
  type = list(string)
}

variable "subnet_ids_code" {}

variable "vpc_id" {}

variable "code-pipeline-branch" {}

variable "code-pipeline-repository" {}

variable "ConnectionArn" {}

variable "useconect" {}

variable "domain" {}

variable "zone_id" {}

variable "account" {}

variable "port" {}

variable "cpu" {}

variable "memory" {}

variable "buildspec" {}

variable "paramate_name" {}

variable "paramate_type" {}

variable "paramate_value" {}