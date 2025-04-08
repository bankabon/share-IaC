// ユーザー作成
resource "snowflake_user" "user" {
  provider             = snowflake.security_admin
  name                 = "${var.snowflake_user}"
  password             = "${var.snowflake_password}"
  default_role         = ""
}