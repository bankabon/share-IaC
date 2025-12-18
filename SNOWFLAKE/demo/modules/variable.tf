variable "env" {
  type        = string
  description = "環境名（例: production, staging, development）"
}

variable "name" {
  type        = string
  description = "リソース名のプレフィックス"
}

variable "snowflake_account" {
  description = "Snowflakeアカウント名"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflakeユーザー名"
  type        = string
}

variable "snowflake_password" {
  description = "Snowflakeパスワード（機密情報のため環境変数での設定を推奨）"
  type        = string
  sensitive   = true
}