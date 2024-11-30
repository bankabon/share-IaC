variable "service" {
  type = string
}

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

variable "role" {
  type = string
}

variable "allowed_security_group_ids" {
  type = map(any)
}

variable "cluster_options" {
  type = list(object({
    num_node_groups         = number
    replicas_per_node_group = number
  }))
  default = []
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
  type    = number
  default = null
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

variable "multi_az_enabled" {
  type    = bool
  default = false
}

variable "register_internal_dns" {
  type    = bool
  default = true
}
