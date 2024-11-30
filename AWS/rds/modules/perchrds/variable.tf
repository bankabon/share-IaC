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

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "backup_retention_period" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "ca_cert_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "kms_key_id" {
  type = string
}

variable "multi_az" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "skip_final_snapshot" {
  type = string
}

variable "option_group_name" {
  type = string
}

variable "performance_insights_enabled" {
  type = string
}

variable "performance_insights_retention_period" {
  type = string
}

variable "parameter_group_name" {
  type = string
}

variable "storage_encrypted" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "copy_tags_to_snapshot" {
  type = string
}

variable "identifier" {
  type = string
}

variable "db_username" {
  type = string
}

variable "allowed_roles" {
  type = list(string)
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