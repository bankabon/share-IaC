variable "name" {}

variable "env" {}

variable "autoscaling_groups" {}

variable "target_group_name" {}

variable "repository_id" {}

variable "branch_name" {}

variable "object_key" {}

variable "build_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "nameとvalueを持つmapの配列。[{name: 'xx', value: ''xx}, {name: 'xx', value: ''xx}]"
  default     = []
}

variable "use_web" {
  type    = bool
  default = true
}

variable "vpc_id" {}

variable "subnet_ids_code" {}

variable "use_github" {
  type = bool
  default = true
}

variable "connectid" {}