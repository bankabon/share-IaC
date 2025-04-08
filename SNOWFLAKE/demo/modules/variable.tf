variable "env" {}
variable "name" {}
variable "snowflake_account" {
  description = "Snowflake account name"
  type        = string
}
variable "snowflake_user" {
  description = "Snowflake user name"
  type        = string
}
variable "snowflake_password" {
  description = "Snowflake password"
  type        = string
}