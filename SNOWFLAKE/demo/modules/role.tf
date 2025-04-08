// SECURITYADMINロールで操作できるように
provider "snowflake" {
  alias = "security_admin"
  role  = "SECURITYADMIN"
}

// ロール作成
resource "snowflake_role" "role" {
  provider = snowflake.security_admin
  name     = "${var.env}-${var.name}-ROLE"
}

// データベースへの権限付与
resource "snowflake_database_grant" "grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.db.name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
}

// スキーマ作成
resource "snowflake_schema" "schema" {
  database     = snowflake_database.db.name
  name         = "${var.env}-${var.name}-SCHEMA"
}

// デフォルトスキーマへの権限付与
resource "snowflake_schema_grant" "schema_default_grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.db.name
  schema_name       = snowflake_schema.schema.name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
}

// スキーマへの権限付与（今後作成されるものも含む）
resource "snowflake_schema_grant" "schema_grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.db.name
  privilege         = "USAGE"
  roles             = [snowflake_role.role.name]
  with_grant_option = false
  on_future         = true
}

// テーブルへの権限付与（今後作成されるものも含む）
resource "snowflake_table_grant" "table_grant" {
  provider      = snowflake.security_admin
  database_name = snowflake_database.db.name
  privilege     = "SELECT"
  roles         = [snowflake_role.role.name]
  on_future     = true
}

// ビューへの権限付与（今後作成されるものも含む）
resource "snowflake_view_grant" "view_grant" {
  provider      = snowflake.security_admin
  database_name = snowflake_database.db.name
  privilege     = "SELECT"
  roles         = [snowflake_role.role.name]
  on_future     = true
}

// ステージへの権限付与
resource "snowflake_stage_grant" "stage_grant" {
  provider      = snowflake.security_admin
  database_name = snowflake_database.db.name
  schema_name   = snowflake_schema.schema.name
  stage_name    = snowflake_stage.stage.name
  privilege     = "READ"
  roles         = [snowflake_role.role.name]
  depends_on    = [snowflake_stage.stage]
}
