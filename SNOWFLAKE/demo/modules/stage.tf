// ステージ作成
resource "snowflake_stage" "stage" {
  name     = "${var.env}_${var.name}_STAGE"
  database = snowflake_database.db.name
  schema   = snowflake_schema.schema.name
}