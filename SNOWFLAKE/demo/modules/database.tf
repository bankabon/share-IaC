// データベース作成
resource "snowflake_database" "db" {
  name     = "${var.env}_${var.name}_DB"
}