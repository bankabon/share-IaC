variable "env" {
  type = string
}

variable "env_short" {
  type = string
}

variable "env_type" {
  type = string
}

variable "domain" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "node_type" {
  type = string
}

variable "number_cache_clusters" {
  type = number
}

variable "maintenance_window" {
  type = string
}

variable "snapshot_window" {
  type = string
}

variable "snapshot_retention_limit" {
  type = number
}

variable "automatic_failover_enabled" {
  type = bool
}

variable "allowed_roles" {
  type = list(string)
}

variable "cluster_name" {
  type    = string
  default = null
}

variable "security_group_name" {
  type    = string
  default = null
}

variable "security_group_description" {
  type    = string
  default = null
}

variable "subnet_group_name" {
  type    = string
  default = null
}

variable "subnet_type" {
  type    = string
  default = null
}
